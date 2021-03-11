/**
 * Class with some assist functions
 * @author Nuno Rebelo - 18022107
 */

const Bcrypt = require("bcrypt");

/**
 * compares a standard password to a hashedPassword
 * @param {string} password 
 * @param {string} hashedPassword 
 */
function passwordsMatch(password, hashedPassword) {
    return Bcrypt.compareSync(password, hashedPassword);
  }
  module.exports.passwordsMatch = passwordsMatch;

/**
 * encrypts a password with a salt value
 * @param {number} salt 
 * @param {string} password 
 */
function passwordToHash(salt, password) {
    return Bcrypt.hashSync(password, salt);
}
module.exports.passwordToHash = passwordToHash;
