extends Player

func _ready():
	invInit([SelectedWeapon.primary, SelectedWeapon.secondary, SelectedWeapon.melee, SelectedWeapon.special], [Primary_slots, Secondary_slots, Melee_slots, Special_slots])
	inventory_slot = 0; inventory_variation = 0
	if !invAdd(inv_items.new(SelectedWeapon.primary, 1, 0.5, AmmoType.slug, global.Primaries[0],2.0)):
		print("failed to add item")
	inventory_slot = 1; inventory_variation = 0 #changes slot to mag_12
	if !invAdd(inv_items.new(SelectedWeapon.secondary, 4, 2.1, AmmoType.bullet, global.Secondaries[0],5.0)):
		print("failed to add item")
	inventory_slot = 3; inventory_variation = 0 #changes slot to OPGun
	if !invAdd(inv_items.new(SelectedWeapon.special, 1, 0.01, AmmoType.slug, global.Specials[0],1.0)):
		print("failed to add item")
	inventory_slot = 2; inventory_variation = 0
	if !invAdd(inv_items.new(SelectedWeapon.melee, 10, 0.5, AmmoType.slug, global.Melees[0],0.25)):
		print("failed to add item")
	inventory_slot = 0; inventory_variation = 1
	if !invAdd(inv_items.new(SelectedWeapon.primary, 0.2, 0.1, AmmoType.bullet, global.Primaries[1],1.0)):
		print("failed to add item")
	inventory_slot = 0; inventory_variation = 0
	invLoadCurent()
	global.enemies = 0
	global.tempkills = defence/5
	levelmusic.stream = LevelSong
	if global.Music_Enabled:
		levelmusic.playing = true
	pausemovement = false
	if Show_Health:
		health_bar.visible = true
	else:
		health_bar.visible = false
	if Show_defence:
		defence_bar.visible = true
	else:
		defence_bar.visible = false
	if Show_stamina:
		stamina_bar.visible = true
	else:
		stamina_bar.visible = false
	if health >= MaxHealth:
		MaxHealth = health
	stamina_bar.max_value = Maxstamina
	stamina_bar.value = Maxstamina
	current_stamina = Maxstamina
	startedWithInstaAim = instantAim
	health_bar.init_health(MaxHealth)
	if shotty:
		shotty.char_skin(Hands)
	global.DamageTaken = 0.0
	global.DamageBlocked = 0.0
	if Mental_State == EmotionalState.focused:
		emotionText.text = "focused"
	elif Mental_State == EmotionalState.agony:
		emotionText.text = "agony"
	elif Mental_State == EmotionalState.disstressed:
		emotionText.text = "disstressed"
	elif Mental_State == EmotionalState.scared:
		emotionText.text = "scared"
	elif Mental_State == EmotionalState.unstable:
		emotionText.text = "unstable"
	else:
		emotionText.text = "stable"
	Fade.visible = true
	emotionCast(emotionText.text)
	Speak("Yeah okay bro... This is really a bad test...")

func _process(delta):
	if Input.is_action_just_pressed("HoldFire"):
		if global.holdfire:
			global.holdfire = false
		else:
			global.holdfire = true
	if Input.is_action_just_pressed("Suicide") && is_dead == false && global.disable_suicide == false:
		health = 0.0
		died()
	if Gain_defense:
		defence = global.tempkills*5
		if defence >= 100:
			global.fullDef = true
		else:
			global.fullDef = false
	if defence >= 101:
		defence = 100
		
	if health >= MaxHealth:
		health = MaxHealth
		
	if PainAmount >= 100.1:
		PainAmount = 100.0
	elif PainAmount <= 0.0:
		PainAmount = 0.0
	if mood >= 210.1:
		mood = 210.0
	elif mood <= 0.0:
		mood = 0.0
	
	if PainAmount < 100.0:
		pain_recovery(delta)
	if mood < 100.0:
		mood_change(delta)
		
	if HeadtraumaTime < 0.0:
		HeadtraumaTime = 0.0
		Headtrauma = false
	if InjuredArmTime < 0.0:
		InjuredArmTime = 0.0
		InjuredArm = false
	if BrokenArmTime < 0.0:
		BrokenArmTime = 0.0
		BrokenArm = false
	if InjuredLegTime < 0.0:
		InjuredLegTime = 0.0
		InjuredLeg = false
	if BrokenLegTime < 0.0:
		BrokenLegTime = 0.0
		BrokenLeg = false
	
	if allowInjuries:
		if HeadtraumaTime > 0.0:
			Headtrauma = true
			HeadtraumaTime -= delta * InjuryRecoveryMulti 
		if InjuredArmTime > 0.0:
			InjuredArm = true
			InjuredArmTime -= delta * InjuryRecoveryMulti
		if BrokenArmTime > 0.0:
			BrokenArm = true
			BrokenArmTime -= delta * InjuryRecoveryMulti
		if InjuredLegTime > 0.0:
			InjuredLeg = true
			InjuredLegTime -= delta * InjuryRecoveryMulti
		if BrokenLegTime > 0.0:
			BrokenLeg = true
			BrokenLegTime -= delta * InjuryRecoveryMulti
		if visibility > 150.0:
			visibility = 150.0
		elif visibility > 0.0:
			visibility -= delta * 10.0
		else:
			visibility = 0.0
		Fade.color.a = visibility*0.01
		
	if affected_by_mood:
		if Mental_State != EmotionalState.vengeful:
			if PainAmount < 75.0 && mood > 75.0 && mood < 150.0 && CanBeInjured && (Mental_State != EmotionalState.unstable or Mental_State != EmotionalState.scared) && feelPain:
				Mental_State = EmotionalState.agony
			elif mood < 75.0 && mood > 50.0:
				Mental_State = EmotionalState.disstressed
			elif mood < 50.0 && mood > 25.0:
				Mental_State = EmotionalState.scared
			elif mood < 25.0:
				Mental_State = EmotionalState.unstable
			elif mood > 150.0:
				Mental_State = EmotionalState.focused
			else:
				Mental_State = EmotionalState.stable
		else:
			PainAmount = 0.0 #Unbearable pain
			mood = 0.0 #Nothing to lose
		

	if Has_stamina:	
		stamina_bar.value = current_stamina / Maxstamina * 100
		current_stamina = clamp(current_stamina, 0, Maxstamina)
		#if current_stamina <= MinStaminaToRun:
			#stamina_bar.set("theme_override_styles/fill",Color(1.0, 0.0, 0.0, 1.0))
		#else:
			#stamina_bar.set("theme_override_styles/fill",Color(0.81, 0.66, 0.0, 1.0))

		#TODO make this stamina be dependand on delta and _process
		# with stamina_cooldown_timer
		if (Char_Running || wallClimbing) && current_stamina > 0:
			drain_stamina(delta)
		if !(Char_Running || wallClimbing) && stamina_cooldown_timer <= 0 && current_stamina <= Maxstamina:
			gain_stamina(delta)
		if current_stamina <= 0:
			Char_Running = false
		if stamina_cooldown_timer > 0:
			stamina_cooldown_timer -= delta
		
		#print("Is running?: ",Char_Running," Stamina: ",current_stamina," stamin_timer_sent: ",stamin_timer_sent," can_regen_stamina: ",can_regen_stamina)

	if health >= 0 && not is_dead && camera_sync:
		if global_position.x > camera_sync.global_position.x && should_camera_sync == true:
			camera_sync.global_position.x = global_position.x
		if global_position.x < camera_sync.global_position.x && should_camera_sync == true:
			camera_sync.global_position.x = global_position.x
		if global_position.y > camera_sync.global_position.y && should_camera_sync == true:
			camera_sync.global_position.y = global_position.y
		if global_position.y < camera_sync.global_position.y && should_camera_sync == true:
			camera_sync.global_position.y = global_position.y
	
	if get_global_mouse_position().x < global_position.x && Player_Mode == PlayerMode.nohands and taunting == false:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if IwantDuckOrTaunt == "taunt":
		if CanHeal_viaTaunt == true && healCD == false:
			healCD = true
			get_tree().create_timer(HealWaitFromTaunt).timeout.connect(healplayer)
		
	if CanBeInjured == false:
		BrokenArm = false
		InjuredArm = false
		BrokenLeg = false
		InjuredLeg = false
		
	
	if Mental_State == EmotionalState.vengeful:
		emotionText.text = "vengeful"
		DamageTakenMulti = 0.5
		SpeedMulti = 1.5
		JumpMulti = 1.5
		AimSpeedMulti = 5.0
		DmgMulti = 2.1
		JumpDmgMulti = 7.5
		PainRecoveryMulti = 0.0
		MoodMulti = 0.0
		levelmusic.pitch_scale = 1.0
		tauntSong.pitch_scale = 1.0
	elif Mental_State == EmotionalState.focused:
		emotionText.text = "focused"
		DamageTakenMulti = 0.75
		SpeedMulti = 1.1
		JumpMulti = 1.25
		AimSpeedMulti = 3.5
		DmgMulti = 1.25
		JumpDmgMulti = 2.5
		PainRecoveryMulti = 2.0
		MoodMulti = 1.5
		levelmusic.pitch_scale = 1.05
		tauntSong.pitch_scale = 1.05
	elif Mental_State == EmotionalState.agony:
		emotionText.text = "agony"
		DamageTakenMulti = 1.1
		SpeedMulti = 0.95
		JumpMulti = 1.0
		AimSpeedMulti = 0.95
		DmgMulti = 1.0
		JumpDmgMulti = 0.95
		PainRecoveryMulti = 0.4
		MoodMulti = 0.7
		levelmusic.pitch_scale = 0.9
		tauntSong.pitch_scale = 0.9
	elif Mental_State == EmotionalState.disstressed:
		emotionText.text = "disstressed"
		DamageTakenMulti = 1.5 #default 1.25
		SpeedMulti = 1.25 #default 0.95
		JumpMulti = 1.0
		AimSpeedMulti = 0.9
		DmgMulti = 1.0
		JumpDmgMulti = 0.8
		PainRecoveryMulti = 0.9
		MoodMulti = 0.7
		levelmusic.pitch_scale = 0.75
		tauntSong.pitch_scale = 0.75
	elif Mental_State == EmotionalState.scared:
		emotionText.text = "scared"
		DamageTakenMulti = 1.5
		SpeedMulti = 1.25
		JumpMulti = 1.0
		AimSpeedMulti = 0.9
		DmgMulti = 1.0
		JumpDmgMulti = 0.9
		PainRecoveryMulti = 1.0
		MoodMulti = 0.8
		levelmusic.pitch_scale = 1.25
		tauntSong.pitch_scale = 1.25
	elif Mental_State == EmotionalState.unstable:
		emotionText.text = "unstable"
		DamageTakenMulti = 2.0
		SpeedMulti = 0.9
		JumpMulti = 0.8
		AimSpeedMulti = 0.7
		DmgMulti = 0.8
		JumpDmgMulti = 0.5
		PainRecoveryMulti = 0.7
		MoodMulti = 0.25
		levelmusic.pitch_scale = 0.5
		tauntSong.pitch_scale = 0.5
	else:
		emotionText.text = "stable"
		DamageTakenMulti = 1.0
		SpeedMulti = 1.0
		JumpMulti = 1.0
		AimSpeedMulti = 1.0
		DmgMulti = 1.0
		JumpDmgMulti = 1.0
		PainRecoveryMulti = 1.0
		MoodMulti = 1.0
		levelmusic.pitch_scale = 1.0
		tauntSong.pitch_scale = 1.0
		
	emotionCast(emotionText.text)
	shotty.dmgMulti(DmgMulti*DMGBoost)
	shotty.gunAim(Aimspeed*AimSpeedMulti*InjuryAimSpeed*HeadInjurySpeed,instantAim)


func _physics_process(delta: float) -> void:
		
	if is_on_floor():
		if was_in_air:
			var fall_distance: float = abs(starting_fall_y - global_position.y)
			var chance_to_fire: float = fall_distance / (Fall_punishment * JumpMulti)
			if (randf_range(0.0,1.5) <= chance_to_fire) && !triggerDicpiplie:
				shotty.fireNOW()
			if fall_distance >= Fall_punishment * JumpMulti:
				BrokenLegTime += 3.0
				InjuredLegTime += 8.0
				Speak("Oof... That was quite a fall.")
			was_in_air = false
	else:
		if !was_in_air:
			starting_fall_y = global_position.y
			was_in_air = true
		if wallClimbing && was_in_air:
			starting_fall_y = global_position.y
		
	if (not is_on_floor() and is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))) and can_wallclimb && ((current_stamina > 0 && wallClimbing) || (current_stamina > MinStaminaToRun && !wallClimbing)):
		velocity.y = -climbspeed
		wallClimbing = true
		stamina_cooldown_timer = Stamina_time_to_recover
	else:
		wallClimbing = false
		
	if not is_on_floor() and !wallClimbing:
		if Jump_Availabe:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		
		velocity += get_gravity() * delta
	else:	
		Jump_Availabe = true

	
	if Input.is_action_pressed("jump") and Jump_Availabe and taunting == false and !wallClimbing:
		velocity.y = JUMP_VELOCITY * JumpMulti
		Jump_Availabe = false
	

	var direction := Input.get_axis("left", "right")
	if Input.is_action_pressed("sprint") && ((current_stamina > 0 && Char_Running) || (current_stamina > MinStaminaToRun && !Char_Running)) && BrokenLeg == false && !wallClimbing:
		#TODO make the sprint only posible when stamina exists and is above the stamina start amount
		ExtraSpeed = SpeedBoost
		Char_Running = true
		stamina_cooldown_timer = Stamina_time_to_recover
	else:
		ExtraSpeed = 1.0
		Char_Running = false
	
	if Input.is_action_just_pressed("change action"):
		if able_to_switch_mode == true:
			if Player_Mode == PlayerMode.regular:
				Player_Mode = PlayerMode.nohands
			else:
				Player_Mode = PlayerMode.regular	
	
	
	if Input.is_action_pressed("down") and is_on_floor() and taunting == false:
		IwantDuckOrTaunt = "duck"
		ExtraSpeed = 0
	elif Input.is_action_just_pressed("taunt") and is_on_floor() and taunting == false && Mental_State != EmotionalState.vengeful:
		IwantDuckOrTaunt= "taunt"
		taunting = true
	elif taunting == false:
		IwantDuckOrTaunt = "none"
	elif Input.is_action_just_pressed("taunt") and is_on_floor() and taunting == true:
		IwantDuckOrTaunt = "none"
		taunting = false

	if direction && IwantDuckOrTaunt == "none" && pausemovement == false:
		if BrokenLeg:
			velocity.x = (direction * SPEED * ExtraSpeed * SpeedMulti) * 0.25
		elif InjuredLeg:
			velocity.x = (direction * SPEED * ExtraSpeed * SpeedMulti) * 0.5
		else:
			velocity.x = direction * SPEED * ExtraSpeed * SpeedMulti
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Headtrauma:
		HeadInjurySpeed = 0.7
		instantAim = false
	else:
		HeadInjurySpeed = 1.0
		if startedWithInstaAim and not (BrokenArm or InjuredArm):
			instantAim = true
	
	if BrokenArm:
		InjuryAimSpeed = 0.5
		instantAim = false
		shotty.gunAim(Aimspeed*AimSpeedMulti*InjuryAimSpeed*HeadInjurySpeed,instantAim)
	elif InjuredArm:
		InjuryAimSpeed = 0.75
		instantAim = false
		shotty.gunAim(Aimspeed*AimSpeedMulti*InjuryAimSpeed*HeadInjurySpeed,instantAim)
	else:
		InjuryAimSpeed = 1.0
		if startedWithInstaAim and not Headtrauma:
			instantAim = true
		shotty.gunAim(Aimspeed*AimSpeedMulti*InjuryAimSpeed*HeadInjurySpeed,instantAim)
		
	
	if IwantDuckOrTaunt != "taunt":
		if levelmusic.stream_paused == true:
			if global.Music_Enabled:
				tauntSong.playing = false
				levelmusic.stream_paused = false
	else:
		if tauntSong.playing == false:
			if global.Music_Enabled:
				tauntSong.playing = true
				levelmusic.stream_paused = true
	
	if Mental_State == EmotionalState.vengeful:
		if global.Music_Enabled && !vengefulTheme.playing:
			vengefulTheme.playing = true
			tauntSong.playing = false
			levelmusic.playing = false
	
	sprite.char_state(IwantDuckOrTaunt)
	sprite.WhatTaunt(TauntName)
	sprite.trigger_animation(velocity,direction,Player_Mode)
	if shotty:
		shotty.modenotifforguns(Player_Mode)
		shotty.state_char_anim(IwantDuckOrTaunt)
		shotty.dmgnumber(inventory_loaded_item.getDmg())
		shotty.bulletnum(inventory_loaded_item.getBHP())
		shotty.cdnumber(inventory_loaded_item.getAttackspeed())
		
		if shotty.mayIswap() == true && Player_Mode == PlayerMode.nohands:
			if Input.is_action_just_pressed("slot1"):#changes slot to Primary
				inventory_slot = 0;
				inventory_variation += 1
				invLoadCurent()
			elif Input.is_action_just_pressed("slot2"):#changes slot to Secondary
				inventory_slot = 1; 
				inventory_variation += 1
				invLoadCurent()
			elif Input.is_action_just_pressed("slot3"):#changes slot to Melee
				inventory_slot = 2; 
				inventory_variation += 1
				invLoadCurent()
			elif Input.is_action_just_pressed("slot4"):#changes slot to Special
				inventory_slot = 3; 
				inventory_variation += 1
				invLoadCurent()
				
			
	# DMGBoost Decay
	if DMGBoost > 1.0:
		DMGBoost -= delta * 0.1
	elif DMGBoost < 1.0:
		DMGBoost += delta * 0.1
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)
		
func handle_enemy_collision(enemy: Enemy):
	if enemy == null && is_dead == false:
		return
	
	var angle_of_collison = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collison > min_stomp_deg && max_stomp_deg > angle_of_collison:
		enemy.hurtEnemy(Stomp_DMG*JumpDmgMulti)
		enemy_stomped()
	else:
		gethitdmg = enemy.damage
		died()
		
func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null && is_dead == false:
		return
	
	var angle_of_collison = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collison > min_stomp_deg && max_stomp_deg > angle_of_collison:
		enemy.hurtEnemy((Stomp_DMG/2)*JumpDmgMulti) #because mafia is stronger in this game
		enemy_stomped()
	else:
		gethitdmg = enemy.damage
		died()

func died():
	health -= (gethitdmg-(gethitdmg*(defence*0.01)))*DamageTakenMulti*TakeDMGBoost
	global.DamageTaken += (gethitdmg-(gethitdmg*(defence*0.01)))*DamageTakenMulti*TakeDMGBoost
	global.DamageBlocked -= ((gethitdmg*(defence*0.01))*DamageTakenMulti*TakeDMGBoost)-gethitdmg
	PainAmount -= (gethitdmg*1.5)
	mood -= (gethitdmg/MoodMulti)
	#injuries...
	Speak("Owie")
	if (gethitdmg*1.5) >= minPain and (gethitdmg*1.5) < maxPain:
		var randomInjury = randi_range(1,5)
		if randomInjury == 1:
			HeadtraumaTime += 5
			visibility += 50
		elif randomInjury == 2:
			InjuredArmTime += 30
		elif randomInjury == 3:
			InjuredLegTime += 15
	elif (gethitdmg*1.5) >= maxPain:
		var randomInjury = randi_range(1,5)
		if randomInjury == 1:
			HeadtraumaTime += 10
			visibility += 100
			Speak("Ugh...")
		elif randomInjury == 2:
			BrokenArmTime += 30
			InjuredArmTime += 60
			Speak("My arm...")
		elif randomInjury == 3:
			InjuredLegTime += 30
			BrokenLegTime += 15
			Speak("Ugh My leg...")
	#injuries end
	global.tempkills = 0 
	if health > 0:
		health_bar.set_health(health)
	if health <= 0:
		if get_tree().get_first_node_in_group("Discord"):
			get_tree().get_first_node_in_group("Discord").update(true)
		is_dead = true
		defence_bar.queue_free()
		stamina_bar.visible = false
		health_bar.visible = false
		Fade.visible = false
		sprite.play("Death")
		char_area.set_collision_layer_value(1,false)
		char_area.set_collision_mask_value(3,false)
		set_collision_layer_value(1,false)
		set_collision_mask_value(3,false)
		set_physics_process(false)
		
		tauntSong.playing = false
		levelmusic.playing = false
		Player_Mode = PlayerMode.regular
		if shotty:
			shotty.modenotifforguns(Player_Mode)
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self,"position", position + Vector2(0,256),1)
		death_tween.tween_callback(func ():
			var screen = lossScreen.instantiate()
			screen.Level = Current_scene
			get_parent().add_child(screen))


func emotionCast(text):
	if global.Emotion != text:
		global.Emotion = text
		if get_tree().get_first_node_in_group("Discord"):
			get_tree().get_first_node_in_group("Discord").update(false)

func Speak(text):
	talkingText.visible_characters = 0
	talkingText.text = text
	var textBuildDuration = talkingText.get_total_character_count() * 0.1
	var tween = create_tween()
	tween.tween_property(talkingText,"visible_characters",talkingText.get_total_character_count(),textBuildDuration)
	await get_tree().create_timer(textBuildDuration+3).timeout
	talkingText.visible_characters = 0
