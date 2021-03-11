/**
 * Class that creates an Instruiction object
 * @author Nuno Rebelo - 18022107
 */

/**
 * default list
 */
var defaultInstructionList = [];

/**
 * constructor to create a new Instruction and add it to the default list
 * @param {string} name 
 */
function Instruction(instruct){
    this.instruct = instruct;

    defaultInstructionList.push(this);
}