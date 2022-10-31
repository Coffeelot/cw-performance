let vehicle


// $(document).on('click', '#track-vehicle', function(e){
//     e.preventDefault()
//     $.post("https://qb-phone/track-vehicle", JSON.stringify({
//         veh: veh,
//     }));
// });


SetupDetailsTuner = function(data) {
    let dt = '';
    if ( data.drivetrain == 1.0 ) {
        dt = 'FWD'
    }
    else if ( data.drivetrain == 0.0) {
        dt = 'RWD'
    }
    else {
        dt = 'AWD (' +  Math.round(data.drivetrain * 10) / 10 + ')'
    }

    if(!data.model){
        $("#tuner-brand").find(".tuner-answer").html('');
        $("#tuner-model").find(".tuner-answer").html('You are not in a car dumbass');
    }
    else {
        $("#tuner-brand").find(".tuner-answer").html(data.brand);
        $("#tuner-model").find(".tuner-answer").html(data.model);
        $("#tuner-rating").find(".tuner-answer").html(data.rating);
        $("#tuner-accel").find(".tuner-answer").html(data.accel);
        $("#tuner-speed").find(".tuner-answer").html(data.speed);
        $("#tuner-handling").find(".tuner-answer").html(data.handling);
        $("#tuner-braking").find(".tuner-answer").html(data.braking);
        $("#tuner-drivetrain").find(".tuner-answer").html(dt);
    }
}

function InitializeVehicle(whip) {
    
    $("#tuner-brand").find(".tuner-answer").html('');
    $("#tuner-model").find(".tuner-answer").html('');
    $("#tuner-rating").find(".tuner-answer").html('');
    $("#tuner-accel").find(".tuner-answer").html('');
    $("#tuner-speed").find(".tuner-answer").html('');
    $("#tuner-handling").find(".tuner-answer").html('');
    $("#tuner-braking").find(".tuner-answer").html('');
    $("#tuner-drivetrain").find(".tuner-answer").html('');
    if (whip != null) {
        SetupDetailsTuner(whip)
    }
}

$(document).on('click', '.tuner-reload', function(e){
    e.preventDefault();

    $.post('https://qb-phone/UpdateVehicle', JSON.stringify({}), function(vehicle){
        InitializeVehicle(vehicle);
    });
});
