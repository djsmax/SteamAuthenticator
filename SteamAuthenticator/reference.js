'use strict';

const Crypto = require('crypto');

/**
 * Returns the current local Unix time
 * @param {number} [timeOffset=0] - This many seconds will be added to the returned time
 * @returns {number}
 */
exports.time = function(timeOffset) {
    return Math.floor(Date.now() / 1000) + (timeOffset || 0);
};

/**
 * Generate a Steam-style TOTP authentication code.
 * @param {Buffer|string} secret - Your TOTP shared_secret as a Buffer, hex, or base64
 * @param {number} [timeOffset=0] - If you know how far off your clock is from the Steam servers, put the offset here in seconds
 * @returns {string}
 */
exports.generateAuthCode = exports.getAuthCode = function(secret, timeOffset) {
    if (typeof timeOffset === 'function') {
        exports.getTimeOffset((err, offset, latency) => {
            if (err) {
                timeOffset(err);
                return;
            }

            let code = exports.generateAuthCode(secret, offset);
            timeOffset(null, code, offset, latency);
        });

        return;
    }

    secret = bufferizeSecret(secret);

    let time = exports.time(timeOffset);

    let buffer = Buffer.allocUnsafe(8);
    buffer.writeUInt32BE(0, 0);
    buffer.writeUInt32BE(Math.floor(time / 30), 4);

    let hmac = Crypto.createHmac('sha1', secret);
    hmac = hmac.update(buffer).digest();

    let start = hmac[19] & 0x0F;
    hmac = hmac.slice(start, start + 4);

    let fullcode = hmac.readUInt32BE(0) & 0x7FFFFFFF;

    const chars = '23456789BCDFGHJKMNPQRTVWXY';

    let code = '';
    for (let i = 0; i < 5; i++) {
        code += chars.charAt(fullcode % chars.length);
        fullcode /= chars.length;
    }

    return code;
};

exports.getTimeOffset = function(callback) {
    let start = Date.now();
    let req = require('https').request({
        "hostname": "api.steampowered.com",
        "path": "/ITwoFactorService/QueryTime/v1/",
        "method": "POST",
        "headers": {
            "Content-Length": 0
        }
    }, (res) => {
        if (res.statusCode != 200) {
            callback(new Error("HTTP error " + res.statusCode));
            return;
        }

        let response = '';
        res.on('data', (chunk) => {
            response += chunk;
        });

        res.on('end', () => {
            try {
                response = JSON.parse(response).response;
            } catch(e) {
                callback(new Error("Malformed response"));
            }

            if (!response || !response.server_time) {
                callback(new Error("Malformed response"));
            }

            let end = Date.now();
            let offset = response.server_time - exports.time();

            callback(null, offset, end - start);
        });
    });

    req.on('error', callback);

    req.end();
};

function bufferizeSecret(secret) {
    if (typeof secret === 'string') {
        // Check if it's hex
        if (secret.match(/[0-9a-f]{40}/i)) {
            return Buffer.from(secret, 'hex');
        } else {
            // Looks like it's base64
            return Buffer.from(secret, 'base64');
        }
    }

    return secret;
}
