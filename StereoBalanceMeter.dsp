declare name        "StereoBalanceMeter";
declare version     "1.0";
declare author      "Vincent Rateau";
declare license     "GPL v3";
declare reference   "www.sonejo.net";
declare description	"A simple Stereo Balance Meter using L-R-Ratio.";


import("stdfaust.lib");


process =  _,_ <: (_, _, stereometer) : (_ , _ , _) : (_, attach);


stereometer =  ampfollowers  <: ratiou, ratiod : ranges   : hbargraph("Stereo Balance Meter",-1,1)
  with{
    // amp follower for l and r
    ampfollowers = an.amp_follower_ud(0.1,0.1), an.amp_follower_ud(0.1,0.1) ;

    // ratio l/r
    ratiou(l,r) =  l / r :  _*(-1) : _+(1);

    // ratio r/l
    ratiod(l,r) =  r / l :  _*(-1) : _+(2) : 1-_;

    // use u if val >= 0, d if val < 0
    ranges(u,d) = u * (u >= 0) +  d * (d < 0);
    };




//-------------------------
  // stereo synth for testing only
  synth =  os.osc(440) : levels ;
  levels = _ <: hgroup("", _ * vslider("L",1,0,1,0.01), _ * vslider("R",1,0,1,0.01));
