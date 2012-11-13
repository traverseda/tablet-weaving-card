height=.6;
//no more then 12 with a length of 50. and a yarnholeR of 5. Give it smaller yarnholes or make it longer.
points=4;
//not counting the bevel, which add ~1cm. Wouldn't be hard to change the code to take into account the bevel, but meh.
length=50;
//5mm = 1cm
yarnholeR=5;
//Feel free to set this manually, But those are some quick setting that should automatically generate a more or less correctly sized hole. With the defaults it's "12.5mm". Double that and you see that the hole is 25mm across. Or 2.5cm
middleholeR=length/2-(yarnholeR*2)-2.5;

//5 is a sane default. For any significant changes you're probably going to need to make changes to the minkowski sum length.
bevel=5;

//If you need to make any changes, it might be better to just rewrite it... Not my cleanest code

//This will cut out all the holes, after minkowski closes
difference(){
	//makes the beveling happen.
	minkowski()
	{
		//This hull generates the basic shape
		hull()
		{
			union()
			{
			cylinder(h = height, r=middleholeR+0.5);
				for ( i = [0 : points] )
				{
				rotate( i * 360 / points, [0, 0, 1])
				//I can use 0.1 for the width, becouse it's all going to be hulled together. The smaller that is the more accurate, but it can't actually be zero for some reason. That should only result in a 0,1mm inaccuracy.
				cube(size = [length/2, 0.1, height]);
				}
			}
		}
		//The hull ends and we create the rounded corners using minkowski
		translate(v = [40, 0, 0]) 
		{
			cylinder(h = height, r=bevel);
		}
	}
	//minkowski ends so we can have nice clean holes, we use a for loop to cut a hole at every point.
	for ( i = [0 : points] )
	{
		translate(v = [40, 0, -1]) 
		{
			rotate( i * 360 / points, [0, 0, 1])
				//Puts the yarn hole -yarhholeR from the edges, not counting the bevel.
				translate(v = [length/2-yarnholeR, 0, -1]) 
				{
					cylinder(h = height+50, r=yarnholeR);
				}
		}
	}
	//cuts the center hole out. If you want something fancier then just a big hole, put it here.
	translate(v = [40, 0, -1]) 
	{
		cylinder(h = height+4, r=middleholeR);
	}
}
