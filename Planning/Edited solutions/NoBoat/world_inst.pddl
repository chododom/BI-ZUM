(define (problem happiness)
   (:domain world)
    (:requirements :strips :typing )
   (:objects
      forest river docks inn town academyLoc lighhouse sea island - location
      
      hero - person                 wizard - wizard                     bank - bank
      flower - flower               tough - tough                       investment - investment
      boat - boat                   map - map                           theft - theft
      frigate - frigate             criminalRecord - criminalRecord     indulgence - indulgence
      caravel - caravel             goodReputation - goodReputation     communityService - communityService
      grain - grain                 brick - brick                       academy - academy
      wood - wood                   metSmugglers - metSmugglers         pirates - pirates
      coin - coin                   captain - captain                   kickedPiratesAss - kickedPiratesAss
      alcohol - alcohol             pirate - pirate			seaTravel - seaTravel
      littleDrunk - littleDrunk     perl - perl				admiral - admiral
      drunk - drunk                 girl - girl
      addicted - addicted           married - married
      bear - bear                   coconut - coconut
      bearSkin - bearSkin           cocaine - cocaine
      impressive - impressive       ring - ring
      water - water                 work - work
      trade - trade                 smugglers - smugglers
      everyone - everyone           fight - fight
   )
   
   
   (:init  
      (path forest river)       (at wood forest)            (at academy academyLoc)
      (path river  forest)      (at flower forest)          (at pirates sea)
      (path river docks)        (at bear forest)            (at perl sea)
      (path docks river)        (at wizard forest)          (at water sea)
      (path docks inn)          (at boat river)             (at girl lighhouse)
      (path inn docks)          (at grain river)            (at coconut island)
      (path docks town)         (at water river)            (at wood island)
      (path town docks)         (at work docks)             (at cocaine island)
      (path town academyLoc)    (at trade docks)            (at married island)
      (path academyLoc town)    (at smugglers docks)	    (at admiral academyLoc)
      (seaPath docks lighhouse) (at alcohol inn)
      (seaPath lighhouse docks) (at everyone inn)
      (seaPath docks sea)       (at fight inn)
      (seaPath sea docks)       (at bank town)
      (seaPath lighhouse sea)   (at investment town)
      (seaPath sea lighhouse)   (at theft town)
      (seaPath sea island)      (at indulgence town)
      (seaPath island sea)      (at communityService town)
      
      (tradable coconut coin)
      (tradable bearSkin coin)
      
      (at hero docks)
   )
   
   ;(:goal (and (is admiral)) )
   ;(:goal (and (is married)) )
   (:goal (and  (own cocaine)) )  
)
