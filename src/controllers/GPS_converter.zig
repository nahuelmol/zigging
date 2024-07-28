const print = @import("std").debug.print;

pub fn converter() void {
    //I need to take actual geoposition
    //how many satelites are available to take data from
    print("trying conversion");
}

pub fn stability_monitor() void {
    //I need acelerometer data
    print("stability");
}

pub fn fall_calculation() void {
    //here shoudl be calculated the possible falls
    //due to different paramters like:
    //radio position and gravity values
    //dynamic variations like body inertia 
    //mass variation
    //charge distribution
    //temperature and pressure
    //aerodynamics variation
    print("trying to calculate the falling trayectory");
}
