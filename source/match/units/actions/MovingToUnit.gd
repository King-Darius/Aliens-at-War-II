extends "res://source/match/units/actions/Moving.gd"

var _target_unit = null
var _target_position_override = null
var _target_offset = null


func _init(target_unit, target_position_override = null):
        _target_unit = target_unit
        if target_position_override != null:
                _target_position_override = target_position_override * Vector3(1, 0, 1)


func _process(_delta):
        if Utils.Match.Unit.Movement.units_adhere(_unit, _target_unit):
                queue_free()


func _ready():
        _target_unit.tree_exited.connect(queue_free)
        if _target_position_override != null:
                _target_offset = _target_position_override - _target_unit.global_position_yless
                if _target_offset.length() < 0.001:
                        _target_offset = Vector3.RIGHT * (_target_unit.radius + _unit.radius)
                _target_position = _target_unit.global_position_yless + _target_offset
        else:
                var direction = _unit.global_position_yless - _target_unit.global_position_yless
                if direction.length() < 0.001:
                        direction = Vector3.RIGHT
                _target_position = (
                        _target_unit.global_position_yless
                        + direction.normalized() * _target_unit.radius
                )
        super()


func _on_movement_finished():
        if Utils.Match.Unit.Movement.units_adhere(_unit, _target_unit):
                queue_free()
        else:
                if _target_offset != null:
                        _target_position = _target_unit.global_position_yless + _target_offset
                else:
                        _target_position = _target_unit.global_position
                _movement_trait.move(_target_position)
