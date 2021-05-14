(define (domain world)
    (:requirements :strips :typing)
    (:types location person flower boat frigate caravel grain wood coin alcohol littleDrunk drunk addicted bear bearSkin impressive water trade everyone wizard tough map criminalRecord goodReputation brick metSmugglers 
            captain pirate perl girl married coconut cocaine ring work smugglers fight bank investment theft indulgence communityService academy pirates kickedPiratesAss seaTravel married admiral)
    (:predicates 
        (path ?from ?to)
        (seaPath ?from ?to)
        (at ?who ?where)
        (own ?what)
        (is ?what)
        (has ?what)
        (tradable ?what ?forWhat)
    )
    
    (:action move
        :parameters (?p - person ?l1 - location ?l2 - location)
        :precondition (and (at ?p ?l1) (path ?l1 ?l2))
        :effect (and
            (at ?p ?l2)
            (not (at ?p ?l1))
        )
    )
    
    (:action moveOnSea
        :parameters (?p - person ?l1 - location ?l2 - location ?seaTravel - seaTravel)
        :precondition (and (at ?p ?l1) (seaPath ?l1 ?l2) (has ?seaTravel))
        :effect (and
            (at ?p ?l2)
            (not (at ?p ?l1))
        )
    )
    
    (:action makeBoat
        :parameters (?p - person ?boat - boat ?wood - wood ?seaTravel - seaTravel)
        :precondition (and (own ?wood) (not (own ?boat)))
        :effect (and
            (not (own ?wood))
            (own ?boat)
	    (has ?seaTravel)
        )
    )
    
    (:action makeFrigate
        :parameters (?p - person ?frigate - frigate ?wood - wood ?grain - grain ?boat - boat ?seaTravel - seaTravel)
        :precondition (and (own ?wood) (own ?boat) (own ?grain) (not (own ?frigate)))
        :effect (and
            (not (own ?wood))
            (not (own ?boat))
            (not (own ?grain))
            (own ?frigate)
	    (has ?seaTravel)
        )
    )
    
    (:action makeCaravel
        :parameters (?p - person ?wood - wood ?boat - boat ?coin - coin ?caravel - caravel ?seaTravel - seaTravel)
        :precondition (and (own ?wood) (own ?boat) (own ?coin) (not (own ?caravel)))
        :effect (and
            (not (own ?wood))
            (not (own ?boat))
            (not (own ?coin))
            (own ?caravel)
 	    (has ?seaTravel)
        )
    )
    
    (:action haveDrink
        :parameters (?p - person ?alcohol - alcohol ?littleDrunk - littleDrunk)
        :precondition (and (own ?alcohol) (not (is ?littleDrunk)))
        :effect (and 
            (not (own ?alcohol))
            (is ?littleDrunk)
        )
    )
    
    (:action getDrunk
        :parameters (?p - person ?alcohol - alcohol ?littleDrunk - littleDrunk ?drunk - drunk)
        :precondition (and (own ?alcohol) (is ?littleDrunk) (not (is ?drunk)))
        :effect (and
            (not (own ?alcohol))
            (not (is ?littleDrunk))
            (is ?drunk)
        )
    )
    
    (:action getAbsolutelyWasted
        :parameters (?p - person ?alcohol - alcohol ?drunk - drunk ?addicted - addicted)
        :precondition (and (own ?alcohol) (is ?drunk) (not (is ?addicted)))
        :effect (and
            (not (own ?alcohol))
            (not (is ?drunk))
            (is ?addicted)
        )
    )
    
    (:action getWood
        :parameters (?p - person ?l - location ?wood - wood)
        :precondition (and (at ?p ?l) (at ?wood ?l) (not (own ?wood)))
        :effect (and
            (own ?wood)
        )
    )
    
    (:action getFlowers
        :parameters (?p - person ?l - location ?flower - flower)
        :precondition (and (at ?p ?l) (at ?flower ?l) (not (own ?flower)))
        :effect (and 
            (own ?flower)
        )
    )
    
    (:action fightBear
        :parameters (?p - person ?l - location ?bear - bear ?bearSkin - bearSkin ?impressive - impressive ?tough - tough)
        :precondition (and (at ?p ?l) (not (own ?bearSkin)) (at ?bear ?l))
        :effect (and 
            (own ?bearSkin)
            (is ?tough)
            (is ?impressive)
        )
    )
    
    (:action getMap
        :parameters (?p - person ?l - location ?wizard - wizard ?map - map ?goodReputation - goodReputation ?alcohol - alcohol)
        :precondition (and (at ?p ?l ) (not (own ?map)) (own ?alcohol) (at ?wizard ?l))
        :effect (and
            (own ?map)
            (not (own ?alcohol))
            (has ?goodReputation)
        )
    )
    
    (:action stealBoat
        :parameters (?p - person ?l - location ?boat - boat ?criminalRecord - criminalRecord ?seaTravel - seaTravel)
        :precondition (and (at ?p ?l) (not (own ?boat)) (at ?boat ?l))
        :effect (and
            (own ?boat)
            (has ?criminalRecord)
     	    (has ?seaTravel)
        )
    )
    
    (:action getGrain
        :parameters (?p - person ?l - location ?grain - grain)
        :precondition (and (at ?p ?l) (not (own ?grain)) (at ?grain ?l))
        :effect (and
            (own ?grain)
        )
    )
    
    (:action refresh
        :parameters (?p - person ?l - location ?water - water ?littleDrunk - littleDrunk ?drunk - drunk ?addicted - addicted)
        :precondition (and (at ?p ?l) (at ?water ?l))
        :effect (and 
            (not (is ?littleDrunk))
            (not (is ?drunk))
            (not (is ?addicted))
        )
    )
    
    (:action work
        :parameters (?p - person ?l - location ?grain - grain ?work - work)
        :precondition (and (at ?p ?l) (not (own ?grain)) (at ?work ?l))
        :effect (and
            (own ?grain)
        )
    )
    
    (:action tradeCoconut
        :parameters (?p - person ?l - location ?coconut - coconut ?coin - coin ?trade - trade)
        :precondition (and (at ?p ?l) (own ?coconut) (not (own ?coin)) (at ?trade ?l) (tradable ?coconut ?coin))
        :effect (and 
            (not (own ?coconut))
            (own ?coin)
        )
    )
    
    (:action tradeBearSkin
        :parameters (?p - person ?l - location ?bearSkin - bearSkin ?coin - coin ?trade - trade)
        :precondition (and (at ?p ?l) (own ?bearSkin) (at ?trade ?l) (not (own ?coin)) (tradable ?bearSkin ?coin))
        :effect (and 
            (not (own ?bearSkin))
            (own ?coin)
        )
    )
    
    (:action meetSmugglers
        :parameters (?p - person ?l - location ?goodReputation - goodReputation ?brick - brick ?metSmugglers - metSmugglers ?smugglers - smugglers)
        :precondition (and (at ?p ?l) (has ?goodReputation) (own ?brick) (not (has ?metSmugglers)) (at ?smugglers ?l))
        :effect (and
            (has ?metSmugglers)
        )
    )
    
    (:action buyAlcohol
        :parameters (?p - person ?l - location ?grain - grain ?alcohol - alcohol)
        :precondition (and (at ?P ?l) (own ?grain) (at ?alcohol ?l))
        :effect (and
            (not (own ?grain))
            (own ?alcohol)
        )
    )
    
    (:action buyEveryoneAlcohol
        :parameters (?p - person ?l - location ?coin - coin ?goodReputation - goodReputation ?everyone - everyone)
        :precondition (and (at ?P ?l) (own ?coin) (at ?everyone ?l))
        :effect (and
            (not (own ?coin))
            (has ?goodReputation)
        )
    )
    
    (:action startFight
        :parameters (?p - person ?l - location ?littleDrunk - littleDrunk ?tough - tough ?fight - fight)
        :precondition (and (at ?p ?l) (is ?littleDrunk) (at ?fight ?l))
        :effect (and
            (is ?tough)
        )
    )
    
    (:action saveUp
        :parameters (?p - person ?l - location ?grain - grain ?coin - coin ?goodReputation - goodReputation ?bank - bank)
        :precondition (and (at ?p ?l) (own ?grain) (not (own ?coin)) (at ?bank ?l))
        :effect (and
            (not (own ?grain))
            (own ?coin)
            (has ?goodReputation)
        )
    )
    
    (:action invest
        :parameters (?p - person ?l - location ?coin - coin ?brick - brick ?goodReputation - goodReputation ?investment - investment)
        :precondition (and (at ?p ?l) (own ?coin) (not (own ?brick)) (at ?investment ?l))
        :effect (and
            (not (own ?coin))
            (own ?brick)
            (has ?goodReputation)
        )
    )
    
    (:action stealCoin
        :parameters (?p - person ?l - location ?coin - coin ?criminalRecord - criminalRecord ?theft - theft)
        :precondition (and (at ?p ?l) (at ?theft ?l) )
        :effect (and
            (own ?coin)
            (has ?criminalRecord) 
        )
    )
    
    (:action buyIndulgence
        :parameters (?p - person ?l - location ?grain - grain ?criminalRecord - criminalRecord ?indulgence - indulgence)
        :precondition (and (at ?p ?l) (own ?grain) (at ?indulgence ?l))
        :effect (and
            (not (own ?grain))
            (not (has ?criminalRecord))
        )
    )
    
    (:action doCommunityService
        :parameters (?p - person ?l - location? ?littleDrunk - littleDrunk ?criminalRecord - criminalRecord ?communityService - communityService)
        :precondition (and (at ?p ?l) (at ?communityService ?l))
        :effect (and
            (is ?littleDrunk)
            (not (has ?criminalRecord))
        )
    )
    
    (:action enrollInAcademy
        :parameters (?p - person ?l - location ?coin - coin ?impressive - impressive ?captain - captain ?academy - academy ?criminalRecord - criminalRecord)
        :precondition (and (at ?p ?l) (own ?coin) (not (has ?criminalRecord)) (at ?academy ?l))
        :effect (and
            (is ?captain)
            (not (own ?coin))
            (is ?impressive)
        )
    )
    
    (:action getAssKickedByPirates
        :parameters (?p - person ?l - location ?tough - tough ?grain - grain ?coin - coin ?brick - brick ?frigate - frigate ?caravel - caravel ?pirates - pirates ?seaTravel - seaTravel)
        :precondition (and (at ?p ?l) (not (is ?tough)) (at ?pirates ?l))
        :effect (and
            (is ?tough)
            (not (own ?grain))
            (not (own ?coin))
            (not (own ?brick))
            (not (own ?frigate))
            (not (own ?caravel))
	    (not (has ?seaTravel))
        )
    )
    
    (:action joinPirates
        :parameters (?p - person ?l - location ?tough - tough ?pirate - pirate ?littleDrunk - littleDrunk ?pirates - pirates)
        :precondition (and (at ?p ?l) (is ?tough) (at ?pirates ?l))
        :effect (and
            (is ?pirate)
            (is ?littleDrunk)
        )
    )
    
    (:action kickPiratesAss
       :parameters (?p - person ?l - location ?tough - tough ?caravel - caravel ?grain - grain ?coin - coin ?brick - brick  ?seaTravel - seaTravel
                    ?boat - boat ?frigate - frigate ?impressive - impressive ?pirates - pirates ?kickedPiratesAss - kickedPiratesAss)
       :precondition (and (at ?p ?l) (is ?tough) (own ?caravel) (at ?pirates ?l))
       :effect (and
            (own ?grain)
            (own ?coin)
            (own ?brick)
            (own ?boat)
            (own ?frigate)
            (own ?caravel)
            (is ?impressive)
            (has ?kickedPiratesAss)
	    (has ?seaTravel)
        )
    )
    
    (:action getPerl
        :parameters (?p - person ?l - location ?perl - perl)
        :precondition (and (at ?p ?l) (not (own ?perl)) (at ?perl ?l))
        :effect (and
            (own ?perl)
        )
    )
    
    (:action getCoconut
        :parameters (?p - person ?l - location ?coconut - coconut)
        :precondition (and (at ?p ?l) (not (own ?coconut)) (at ?coconut ?l))
        :effect (and
            (own ?coconut)
        )
    )
    
    (:action getCocaine
        :parameters (?p - person ?l - location ?cocaine - cocaine ?map - map ?addicted - addicted ?frigate - frigate ?metSmugglers - metSmugglers ?brick - brick)
        :precondition (and (at ?p ?l) (at ?cocaine ?l) (own ?map) (is ?addicted) (own ?frigate) (has ?metSmugglers) (own ?brick))
        :effect (and
            (own ?cocaine)
        )
    )
    
    (:action makeRing
        :parameters (?p - person ?brick - brick ?perl - perl ?ring - ring)
        :precondition (and (own ?brick) (own ?perl) (not (own ?ring)))
        :effect (and
            (own ?ring)
            (not (own ?brick))
            (not (own ?perl))
        )
    )

    (:action marry
	:parameters (?p - person ?l - location ?impressive - impressive ?ring - ring ?flower - flower ?goodReputation - goodReputation ?criminalRecord - criminalRecord ?drunk - drunk ?addicted - addicted ?married - married)
	:precondition (and (is ?impressive) (own ?ring) (own ?flower) (has ?goodReputation) (not (has ?criminalRecord)) (not (is ?drunk)) (not (is ?addicted)) (at ?married ?l) )
	:effect (and
	    (is ?married)
	)
    )

    (:action becomeAdmiral
	:parameters (?p - person ?l - location ?captain - captain ?littleDrunk - littleDrunk ?drunk - drunk ?addicted - addicted ?kickedPiratesAss - kickedPiratesAss ?admiral - admiral)
	:precondition (and (is ?captain) (has ?kickedPiratesAss) (at ?p ?l) (not (is ?littleDrunk)) (not (is ?drunk)) (not (is ?addicted)) (at ?admiral ?l))
	:effect (and
	    (is ?admiral)
	)
    )
)
