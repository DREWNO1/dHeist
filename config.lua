Config = {}

Config.PedLocation = vec4(422.504272, 64.693642, 96.977882, 122.466202)
Config.BankLocation = vec3(-351.911926, -51.200195, 48.036457)

Config.Debug = {
    activated = true,
    cooldown = 0,
    limitGuards = false,
    maxGuards = 0
}

Config.MinimumGuards = 3
Config.GuardModel = "s_m_m_security_01"
Config.BankGuards = {
    vec4(-353.943329, -55.145832, 48.036579, 45.430637),
    vec4(-353.458282, -53.221733, 48.036530, 86.057297),
    vec4(-354.498535, -53.534225, 48.046288, 70.148148),
    -- vec4(-357.309265, -53.586132, 48.036755, 344.825531),
    -- vec4(-355.696625, -50.767075, 48.036415, 346.226471),
    -- vec4(-349.975189, -54.497452, 48.014786, 97.385460),
    -- vec4(-349.763763, -56.471817, 48.014835, 53.623421),
    -- vec4(-351.399689, -54.016129, 48.014801, 117.064903),
    -- vec4(-353.391937, -56.852306, 48.014809, 264.094604),
    -- vec4(-349.952850, -58.463226, 48.014870, 36.848351)
}

Config.GuardsCombatAttributes = {
  -- This ped can make decisions on whether to strafe or not based on distance to destination, recent bullet events, etc.
  CA_CAN_USE_DYNAMIC_STRAFE_DECISIONS	= 4,
  -- Ped will always fight upon getting threat response task
  CA_ALWAYS_FIGHT = 5,
  -- Deprecated
  CA_IS_A_GUARD = 10,
  -- Ped may advance
  CA_AGGRESSIVE = 13,
  -- Ped can investigate events such as distant gunfire, footsteps, explosions etc
  CA_CAN_INVESTIGATE = 14,
  -- Ped can use a radio to call for backup (happens after a reaction)
  CA_CAN_USE_RADIO = 15,
  -- Ped will be able to chase their targets if both are on foot and the target is running away
  CA_CAN_CHASE_TARGET_ON_FOOT = 21,
  -- Ped is allowed to use proximity based fire rate (increasing fire rate at closer distances)
  CA_USE_PROXIMITY_FIRING_RATE = 24,
  -- This will disable the flinching combat entry reactions for peds, instead only playing the turn and aim anims
  CA_DISABLE_ENTRY_REACTIONS = 26,
  -- Force ped to be 100% accurate in all situations (added by Jay Reinebold)
  CA_PERFECT_ACCURACY = 27,
  -- If we don't have cover and can't see our target it's possible we will advance, even if the target is in cover
  CA_CAN_USE_FRUSTRATED_ADVANCE	= 28,
  -- Allow shooting of our weapon even if we don't have LOS (this isn't X-ray vision as it only affects weapon firing)
  CA_CAN_SHOOT_WITHOUT_LOS = 30,
  -- Ped will try to maintain a min distance to the target, even if using defensive areas (currently only for cover finding + usage) 
  CA_MAINTAIN_MIN_DISTANCE_TO_TARGET = 31,
  -- Allows ped to use steamed variations of peeking anims
  CA_CAN_USE_PEEKING_VARIATIONS	= 34,
  -- When defensive area is reached the area is cleared and the ped is set to use defensive combat movement
  CA_OPEN_COMBAT_WHEN_DEFENSIVE_AREA_IS_REACHED = 37,
  -- Disables bullet reactions
  CA_DISABLE_BULLET_REACTIONS = 38,
  -- This ped is ignored by other peds when wanted
  CA_IGNORED_BY_OTHER_PEDS_WHEN_WANTED = 40,
  -- Ped is allowed to flank
  CA_CAN_FLANK = 42,
  -- Ped will switch to defensive if they are in cover
  CA_SWITCH_TO_DEFENSIVE_IF_IN_COVER = 44,
  -- Ped is allowed to fight armed peds when not armed
  CA_CAN_FIGHT_ARMED_PEDS_WHEN_NOT_ARMED = 46,
  -- Ped may use reduced accuracy with large number of enemies attacking the same local player target
  CA_USE_ENEMY_ACCURACY_SCALING	= 49,
  -- Ped is allowed to charge the enemy position
  CA_CAN_CHARGE = 50,
  -- Always equip best weapon in combat
  CA_ALWAYS_EQUIP_BEST_WEAPON = 54,
  -- Disables peds seeking due to no clear line of sight
  CA_DISABLE_SEEK_DUE_TO_LINE_OF_SIGHT = 57,
  -- To be used when releasing missions peds if we don't want them fleeing from combat (mission peds already prevent flee)
  CA_DISABLE_FLEE_FROM_COMBAT = 58,
  -- Ped may throw a smoke grenade at player loitering in combat
  CA_CAN_THROW_SMOKE_GRENADE = 60,
  -- Makes it more likely that the ped will continue targeting a target with blocked los for a few seconds
  CA_CAN_IGNORE_BLOCKED_LOS_WEIGHTING = 67,
  -- Disables the react to buddy shot behaviour.
  CA_DISABLE_REACT_TO_BUDDY_SHOT = 68,
  -- If set on a ped, they will not flee when all random peds flee is set to TRUE (they are still able to flee due to other reasons)
  CA_DISABLE_ALL_RANDOMS_FLEE = 78,
  -- This ped will send out a script DeadPedSeenEvent when they see a dead ped
  CA_WILL_GENERATE_DEAD_PED_SEEN_SCRIPT_EVENTS = 79,
  --When peds are tasked to go to combat, they keep searching for a known target for a while before forcing an unknown one
  CA_PREFER_KNOWN_TARGETS_WHEN_COMBAT_CLOSEST_TARGET = 88,
  1,
  2
}

Config.GuardsFlags = {
    2, -- HasBulletProofVest
    6, -- NoCriticalHits,
    107, -- DontActivateRagdollFromBulletImpact
    108, -- DontActivateRagdollFromExplosions
    109, -- DontActivateRagdollFromFire
    188, -- DisableHurt
    430, -- IgnoreBeingOnFire
    229  -- DisablePanicInVehicle
}

Config.VaultDoors = {
    id = "BANK_1",
    hash = 2121050683, 
    coords = vector4(-352.74, -53.57, 49.18, 250.86),
    openHeading = 150
}