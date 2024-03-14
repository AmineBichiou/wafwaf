const mongoosee = require('mongoose');
const { Schema } = mongoosee;


const TreatsSchema = new Schema({
    treatName: {
        type: String,
        required: true,
    },
    treatDescription: {
        type: String,
        required: false,
    },
    treatImage: {
        type: String,
        
    },
});

const Treats = mongoosee.model('Treats', TreatsSchema);

module.exports = Treats;
