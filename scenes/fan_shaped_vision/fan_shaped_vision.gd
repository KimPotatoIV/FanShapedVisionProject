extends Node2D

##################################################
const RAY_COUNT: int = 16
const RAY_LENGTH: float = 200.0
const FOV: float = 90.0
const TIMER_WAIT_TIME: float = 0.01
# 시야를 구성할 RayCast2D의 개수, 길이, 시야각(FOV), 업데이트 간격 설정

var ray_timer_node: Timer
# RayCast2D를 주기적으로 갱신할 Timer 노드
var ray_array: Array = []
# 시야 계산용 RayCast2D 배열
var vision_polygon_node: Polygon2D
# 시야를 시각화할 Polygon2D 노드

##################################################
func _ready() -> void:
	ray_timer_node = $RayTimer
	vision_polygon_node = $VisionPolygon
	# Timer 및 Polygon2D 노드 설정
	
	ray_timer_node.wait_time = TIMER_WAIT_TIME
	ray_timer_node.one_shot = true
	ray_timer_node.connect("timeout", Callable(self, "_on_ray_timer_timeout"))
	ray_timer_node.start()
	# Timer 설정
	
	init_ray_cast()
	# RayCast 초기화

##################################################
func init_ray_cast() -> void:
# 시야 범위에 따라 여러 개의 RayCast2D를 생성하고 배치
	var start_angle: float = -FOV / 2.0
	# 시작 각도 (좌측 끝)
	var angle_interval: float = FOV / (RAY_COUNT - 1)
	# Ray 간 각도 간격
	
	for i in range(RAY_COUNT):
		var angle = deg_to_rad(start_angle + angle_interval * i)
		
		var ray_cast: RayCast2D = RayCast2D.new()
		ray_cast.target_position = Vector2(RAY_LENGTH, 0).rotated(angle)
		ray_cast.enabled = true
		# Ray 생성 및 설정
		
		add_child(ray_cast)
		ray_array.append(ray_cast)
		# 현재 노드에 자식으로 추가하고 배열에 저장

##################################################
func _on_ray_timer_timeout() -> void:
# Timer에 의해 호출되어 RayCast 정보를 바탕으로 시야 Polygon 생성
	var points: Array[Vector2] = [Vector2.ZERO]
	# 시야의 기준점 (중심)
	var collided: bool = false
	# 충돌 여부 판단용 플래그
	
	for ray in ray_array:
		var ray_cast: RayCast2D = ray
		var collision_point: Vector2
		
		if ray_cast.is_colliding():
			collision_point = to_local(ray_cast.get_collision_point())
			# 충돌 시, 충돌 위치를 로컬 좌표로 변환
			# get_collision_point()는 글로벌 좌표계로 반환을 하기 때문
			collided = true
		else:
			collision_point = ray_cast.target_position
			# 충돌 없을 경우 Ray의 끝 지점을 사용
		
		points.append(collision_point)
	
	vision_polygon_node.polygon = points
	# Polygon2D의 꼭짓점 지정 (첫 점은 항상 중심점)
	# polygon은 로컬 좌표계로 입력을 해야 하기 때문에 위에서 to_local()를 사용
	
	if collided:
		vision_polygon_node.color = Color(1, 0, 0, 0.25)
	else:
		vision_polygon_node.color = Color(0, 1, 0.25, 0.25)
	# 충돌 여부에 따라 색상 변경 (빨강 또는 연두)
	
	ray_timer_node.start()
	# 타이머 재시작
