java_import 'wblut.geom.WB_AABB'
java_import 'wblut.geom.WB_Point'
java_import 'wblut.geom.WB_Plane'
java_import 'wblut.geom.WB_Transform3D'
java_import 'wblut.geom.WB_Vector'
java_import 'wblut.processing.WB_Render3D'
java_import 'wblut.math.WB_Ease'

boolean ORTHOROT
boolean ORTHO

WB_Ease easeIn,easeOut1R,easeOut1T,easeOut2R,easeOut2T,easeInOut
FragmentTree fragmentTree
WB_Render3D render

int maxLevel

int numFrames
int frameCounter
float hueshift
int slices
float rotationDirection,  rotationRange
int rotationMode
AABB

float explode
fragment
int hueDirection
shift

def setup
  noCursor
  colorMode(HSB)
  render=WB_Render3D.new(self)
  easeIn=WB_Ease.getSine
  easeInOut=WB_Ease.getSine
  strokeWeight(2.0)
  numFrames=540
  init
end

def init
  ORTHO=true
  ORTHOROT=ORTHO?rand(100)<50:false
  rotationRange=rand(1.0..3)*HALF_PI
  rotationDirection=((rand(100)<50)?-1:1)
  rotationMode=rand(2.0)
  createMesh
  hueshift=rand(256.0)
  hueDirection=rand(100)<50?-1:1
  easeOut2R= rand(100)<33.33?WB_Ease.getElastic(1.0, 0.3):rand(100)<50.0?WB_Ease.getBounce:WB_Ease.getSine
  easeOut2T= rand(100)<50?WB_Ease.getQuint:WB_Ease.getBounce
  easeOut1R= rand(100)<50?WB_Ease.getElastic(1.0, 0.3):WB_Ease.getSine
  easeOut1T= rand(100)<50?WB_Ease.getElastic(1.0, 0.3):WB_Ease.getQuint//EaseElastic(1.0, 0.6)//getElastic
  slices=rand(8..14.0)
  explode=rand(100.0)<50?0.0:20.0
  while(maxLevel<slices)
    fragmentTreeSplit
    AABB=fragmentTree.determineAABB
  end
  frameCounter=0
  shift=WB_Point.new
end

def createMesh
  mesh = HE_Mesh.new(HEC_Box.new(self)250, 250, 250, 1, 1, 1))
  HE_FaceIterator fItr = mesh.fItr
  HE_Face f
  while (fItr.hasNext)
    f=fItr.next
    f.setColor(color(0))
  end
  fragmentTree = Fragment.newTree(mesh)
  maxLevel=0
  AABB=fragmentTree.determineAABB(0.0, 0)
end

def fragmentTreeSplit
  Movement M
  P
  roll=rand(8)
  angleRoll= (rand < 0.5) ? -1 : 1
  angle=angleRoll * rand(PI/6..PI/1.5)
  movement = rand(20.0..100.0)
  case(roll)
  when 0
    int xRoll=rand(4..17)
    plane = WB_Plane.new(AABB.getMin(0)+AABB.getWidth*0.05*xRoll, 7.5*rand(-9..9.0), 7.5*rand(-9..9.0), rand(100)<50?1:-1, 0, 0)
    movement=Movement.new(plane, angle, false)
  when 1
    int yRoll=rand(4..17)
    plane = WB_Plane.new(7.5*rand(-9..9.0), AABB.getMin(1)+AABB.getHeight*0.05*yRoll, 7.5*rand(-9..9.0), 0, rand(100)<50?1:-1, 0)
    movement=Movement.new(plane, angle, false)
  when 2
    int zRoll=rand(4..17)
    plane = WB_Plane.new(7.5*rand(-9..9.0), 7.5*rand(-9..9.0), AABB.getMin(2)+AABB.getDepth*0.05*zRoll, 0, 0, rand(100)<50?1:-1)
    movement=Movement.new(plane, angle, false)
  when 3
    plane = WB_Plane.new(7.5*rand(-9..9.0), 7.5*rand(-9..9.0), 7.5*rand(-9..9.0), rand(-1..1.0), rand(-1..1.0), rand(-1..1.0))
    movement=Movement.new(plane, angle, false)
  when 4
    xRoll=rand(3..18)
    plane = WB_Plane.new(AABB.getmovementin(0)+AABB.getWidth*0.05*xRoll, 0, 0, rand(100)<50?1:-1, 0, 0)
    movement=Movement.new(plane, movement, WB_Vector.new(0, rand(-1..1.0), rand(-1..1.0)))
  when 5
    yRoll=rand(3..18)
    plane = WB_Plane.new(0, AABB.getMin(1)+AABB.getHeight*0.05*yRoll, 0, 0, rand(100)<50?1:-1, 0)
    movement=Movement.new(plane, movement, WB_Vector.new(rand(-1..1.0), 0,rand(-1..1.0)))
  when 6
    zRoll=rand(3..18)
    plane = WB_Plane.new(0, 0, AABB.getMin(2)+AABB.getDepth*0.05*zRoll, 0, 0, rand(100)<50?1:-1)
    movement=Movement.new(plane, movement, WB_Vector.new(rand(-1..1.0),rand(-1..1.0),0))
  else
    plane = WB_Plane.new(AABB.getMin(0)+AABB.getDepth*0.05*rand(3..18), AABB.getMin(1)+AABB.getDepth*0.05*rand(3..18), AABB.getMin(2)+AABB.getDepth*0.05*rand(3..18), rand(-1..1.0), rand(-1..1.0), rand(-1..1.0))
    movement=Movement.new(plane, movement, true)
  end
  maxLevel++
  movement.level=maxLevel
  fragmentTree.split(movement)
end

def draw
  if (frameCount<numFrames/2)
    frameCounter=frameCount
  else if (frameCount>numFrames/2+19)
  frameCounter=frameCount-19
else
frameCounter=numFrames/2
end
if (ORTHO) ortho
  translate(width / 2, height / 2)
  float phase = map(frameCounter-1 , 0, numFrames, 0, 1)
  float phase2 = map(frameCount-1 , 0, (numFrames+20), 0, 1)
  float angle=phase*TWO_PI
  float f=(0.5-0.5*cos(angle))*maxLevel
  background(50)//(hueshift+128)%256,40,50)
  AABB=fragmentTree.determineAABB(f, frameCounter-1)
  shift.mulAddMulSelf(0.5, 0.5, AABB.getCenter)
  pushMatrix
  fill(0)
  if (ORTHOROT)
    rotateX(asin(1.0/sqrt(3.0)))
    rotateY(QUARTER_PI)
  end
  rotate(phase2)
  translate(-shift.xf, -shift.yf, -shift.zf)
  fragmentTree.draw(f, frameCounter-1)
  popMatrix

  if (frameCounter==numFrames)
    frameCount=0
    maxLevel=0
    init
  end
end

def rotate(float phase2)
  if (rotationMode==0)
    if (phase2>0.5)

      rotateX(rotationDirection*(float)easeInOut.easeInOut(2*phase2-1.0)*rotationRange)
    end
  else if (rotationMode==1)
  if (phase2>0.5)

    rotateY(rotationDirection*(float)easeInOut.easeInOut(2*phase2-1.0)*rotationRange)
  end
end
end


class FragmentTree
  attr_reader :root

  def initialize(mesh)
    @root = Fragment.new(mesh)
  end

  def split(final Movement movement)
    root.split(movement, rand(2..6) * 10)
  end

  def determineAABB(f, counter)
    WB_AABB.new.tap do |aabb|
      root.determineAABB(f, aabb, counter)
    end
  end

  def determineAABB
    WB_AABB.new.tap do |aabb|
      root.determineAABB(aabb)
    end
  end

  def draw(f, counter)
    root.draw(f, counter)
  end
end

class Fragment
  Fragment parent
  Fragment child0, child1
  Movement parentToChild
  mesh
  invTmesh
  dynMesh
  int level

  Fragment(final mesh)
  this.mesh = mesh.get
  invTmesh = mesh.get
  dynMesh = mesh.get
  parentToChild = null
  parent = null
  child0 = null
  child1 = null
  level = 0
end

Fragment(final mesh,  final Fragment parent, final Movement parentToChild)
this.mesh = mesh.get
this.parentToChild = parentToChild
this.parent = parent
invTmesh = mesh.get
Fragment p = this
do
if ( p.parentToChild.nil?)
  final T = p.parentToChild.getInvT(1.0)
  invTmesh.transformSelf(transform)
end
p = p.parent
end while (p != null)
dynMesh = mesh.get
level=parent.level+1

end

def split(Movement movement, sep)
  if ((child0 == null) && (child1 == null))
    split=mesh.get
    split.removeSelection("caps")
    sm = new HEMC_SplitMesh.setPlane(movement.plane).setMesh(split)
    result = sm.create
    submesh0=result.getMesh(0).get
    submesh1=result.getMesh(1).get
    float hue=(hueshift+256+hueDirection*maxLevel*8)%256
    if (submesh0.getNumberOfVertices > 0 )
      fitr = submesh0.getSelection("caps").fItr
      while (fitr.hasNext)
        fitr.next.setColor(color(hue, 255, 255))
      end
      child0 = Fragment.new(submesh0, this, null)
    end
    if (submesh1.getNumberOfVertices > 0)
      fitr = submesh1.getSelection("caps").fItr
      while (fitr.hasNext)
        fitr.next.setColor(color(hue, 255, 255))
      end
      submesh1.transformSelf(movement.getT(1.0))
      child1 = Fragment.new(submesh1, this, movement)
    end
  else
  if (child0 != null)
    child0.split(movement,sep)
  end
  if (child1 != null)
    child1.split(movement,sep)
  end


end
end

def determineAABB(final f, aabb, int counter)
  if ((child0 == null) && (child1 == null))
    aabb.expandToInclude(getMesh(f, counter).getAABB)
  else
  if (child0 != null)
    child0.determineAABB(f, aabb, counter)
  end
  if (child1 != null)
    child1.determineAABB(f, aabb, counter)
  end
end
end

def determineAABB(aabb)
  if ((child0 == null) && (child1 == null))
    aabb.expandToInclude(mesh.getAABB)
  else
  if (child0 != null)
    child0.determineAABB( aabb)
  end
  if (child1 != null)
    child1.determineAABB( aabb)
  end
end
end

def draw(final f, int counter)
  if (((child0 == null) && (child1 == null))||(f-0.01)<=level)
    final m = getMesh(f, counter)
    pushMatrix
    noStroke
    fill(255)
    render.drawFacesFC(m)
    popMatrix
  else
  if (child0 != null)
    child0.draw(f, counter)
  end
  if (child1 != null)
    child1.draw(f, counter)
  end
end
end

def getMesh(f, int counter)
  if (f<=0.01)
    return invTmesh
  else if (f>=level-0.01)
  return mesh
else
Fragment p = this
float fracf
transform=WB_Transform.new
do
if (p.parentToChild.nil?)
  fracf=(p.level-f).clamp(0.0, 1.0)
  if (counter<numFrames/2)
    fracf=1.0-fracf
  end

  if (fracf<=0.5)
    fracf=(float)easeIn.easeInOut(fracf)
  else
  fracf=(counter<numFrames/2)? ((p.parentToChild.translation)?(float)easeOut1T.easeInOut(fracf):(float)easeOut1R.easeInOut(fracf)):((p.parentToChild.translation)?(float)easeOut2T.easeInOut(fracf):(float)easeOut2R.easeInOut(fracf))
end

if (counter<numFrames/2)
  fracf=1.0-fracf
end
transform.addTransform(p.parentToChild.getInvT(fracf))
end
p = p.parent
end while (p != null && f<p.level)
sItr=mesh.vItr
tItr=dynMesh.vItr
vertex=WB_Point.new
while (sItr.hasNext)
  transform.applyAsPointInto(sItr.next, tItr.next)
end
return dynMesh
end
end

end


class Movement
  attr_reader :movement

  def initialize(args)
    @movement = args.merge(default)
  end

  def default
    { plane: nil,
      transform: nil,
      origin: nil
      direction: nil,
      reverse: nil,
      amount: 0.0,
      translate: false,
      level: 0 }
    end

    Movement(plane)
    this.plane=plane.get
    this.plane.flipNormal
    this.translation=true
    this.amount=0.0
    this.origin=this.plane.getOrigin
    this.direction = WB_Vector.new(1, 0, 0)
    this.reverseDirection=this.direction.mul(-1)
    this.level=0
  end

  Movement(plane, amount, boolean translation)
  this.plane=plane.get
  this.translation=translation
  this.amount=amount
  this.origin=this.plane.getOrigin
  if (translation)
    this.direction = this.plane.getNormal.cross(WB_Vector.new(rand(-1..1.0), rand(-1..1.0), rand(-1..1.0)))
    this.direction.normalizeSelf
  else
    this.direction=this.plane.getNormal
  end
  this.reverseDirection=this.direction.mul(-1)
  this.level=0
end

Movement(plane, amount, shift)
this.plane=plane.get
this.translation=true
this.amount=amount
this.origin=this.plane.getOrigin
this.direction = WB_Vector.new(shift)
this.direction.normalizeSelf
this.reverseDirection=this.direction.mul(-1)
this.level=0
end

def getT(f)
  fAmount=f*amount
  transform = WB_Transform.new
  if (translation)
    transform.addTranslate(direction.mul(fAmount))
    transform.addTranslate(plane.getNormal.mul(-f*f*explode))
  else
  transform.addRotateAboutAxis(fAmount, origin, direction)
  transform.addTranslate(plane.getNormal.mul(-f*f*explode))
end
return transform
end

def getInvT(f)
  fAmount=f*amount
  transform = WB_Transform.new
  if (translation)
    transform.addTranslate(plane.getNormal.mul(f*f*explode))
    transform.addTranslate(reverseDirection.mul(fAmount))
  else
  transform.addTranslate(plane.getNormal.mul(f*f*explode))
  transform.addRotateAboutAxis(fAmount, origin, reverseDirection)
end
return transform
end

def inverse
  Movement rev=Movement.new(plane)
  rev.plane=plane.get
  rev.origin=WB_Point.new(origin)
  rev.direction=WB_Vector.new(reverseDirection)
  rev.reverseDirection=WB_Vector.new(direction)
  rev.amount=amount
  rev.translation=translation
  rev.level=level
  return rev
end
end

def settings
  size(800, 800, P3D)
  smooth(16)
end
