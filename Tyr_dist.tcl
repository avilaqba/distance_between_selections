set output [ open  distTyr.txt w]
set dcdincr 1
set firstframe 0
set lastframe -1 
set prefix sys1
set cntr 0
mol load pdb step3_pbcsetup.pdb
mol addfile step3_pbcsetup.xplor.ext.psf
set Tyr48 [atomselect top "index 667 679 684 682 674 675"]
set Tyr137 [atomselect top "index 2027 2019 2020 2022 2024 2029"]

for {set b 1} {$b <= 4} {incr b 2} {
    set firstdcd $b
    set lastdcd [expr $b+1]
 
    for { set i $firstdcd } { $i <= $lastdcd } { incr i $dcdincr } {
        mol addfile ${prefix}_${i}.dcd first $firstframe last $lastframe waitfor all
        }
		
    set n [molinfo top get numframes]

    for {set f 0} {$f <= $n} {incr f 1} {
		$Tyr48 frame $f
		$Tyr48 update
		$Tyr137 frame $f
		$Tyr137 update
	    set  x1 [  lindex [ measure center $Tyr48  ]  0  ]
	    set  y1 [  lindex [ measure center $Tyr48  ]  1  ]
	    set  z1 [  lindex [ measure center $Tyr48  ]  2  ]
	    set  x2 [  lindex [ measure center $Tyr137 ]  0  ]
	    set  y2 [  lindex [ measure center $Tyr137 ]  1  ]
	    set  z2 [  lindex [ measure center $Tyr137 ]  2  ]
	    set dist [ expr  sqrt ( ($x1 -  $x2 )*($x1 -  $x2 ) + ($y1 -  $y2 )*($y1 -  $y2 ) +($z1 -  $z2 )*($z1 -  $z2 )  ) ]
        set fr [ expr $f + ($n*$cntr) ]
		puts $output "$fr $dist"
        }
	incr cntr	
    animate delete all
    }

close $output