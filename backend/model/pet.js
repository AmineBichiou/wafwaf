const mongoose = require('mongoose');
const { Schema } = mongoose;
const petSchema = new Schema({
    name: String,
    race : Boolean,

});

const Pet = mongoose.model('Pet', petSchema);

module.exports = Pet;