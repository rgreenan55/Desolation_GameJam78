class_name Room extends Resource

enum RoomType { Entrance, Empty, Chest, Enemy, Exit }
var room_type : RoomType;

var connections : Dictionary = {}
