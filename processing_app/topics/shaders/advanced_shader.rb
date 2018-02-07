# sketch from processing wiki
# https://github.com/processing/processing/wiki/Advanced-OpenGL

java_import 'processing.opengl.PJOGL'
java_import 'java.nio.ByteBuffer'
java_import 'java.nio.ByteOrder'
java_import 'java.nio.FloatBuffer'
java_import 'java.nio.IntBuffer'
java_import 'com.jogamp.opengl.GL'
java_import 'com.jogamp.opengl.GL4ES3'
java_import 'java.lang.Float'
java_import 'java.lang.Integer'

attr_reader :shader, :positions, :colors, :indices, :pos_buffer, :color_buffer, :index_buffer
attr_reader :posVboId, :colorVboId, :indexVboId, :posLoc, :colorLoc, :intBuffer, :angle

def settings
  size(800, 600, P3D)
  PJOGL.profile = 4
end

def setup
  sketch_title 'Advanced Open-GL'
  @shader = load_shader(data_path('frag.glsl'), data_path('vert.glsl'))
  @positions = Array.new(32, 0)
  @colors = Array.new(32, 0)
  @indices = Array.new(12, 0)
  @angle = 0
  @pos_buffer = allocate_direct_float_buffer(32)
  @color_buffer = allocate_direct_float_buffer(32)
  @index_buffer = allocate_direct_int_buffer(12)
  pgl = beginPGL
  gl = pgl.gl.getGL4ES3
  # Get GL ids for all the buffers
  intBuffer = IntBuffer.allocate(3)
  gl.glGenBuffers(3, intBuffer)
  @posVboId = intBuffer.get(0)
  @colorVboId = intBuffer.get(1)
  @indexVboId = intBuffer.get(2)
  # Get the location of the attribute variables.
  shader.bind
  @posLoc = gl.glGetAttribLocation(shader.glProgram, 'position')
  @colorLoc = gl.glGetAttribLocation(shader.glProgram, 'color')
  shader.unbind
  endPGL
end

def draw
  background(255)
  # Geometry transformations from Processing are automatically passed to the shader
  # as long as the uniforms in the shader have the right names.
  translate(width / 2, height / 2)
  rotate_x(angle)
  rotate_y(angle * 2)
  update_geometry
  pgl = beginPGL
  gl = pgl.gl.getGL4ES3
  shader.bind
  gl.glEnableVertexAttribArray(posLoc)
  gl.glEnableVertexAttribArray(colorLoc)
  # Copy vertex dat@angle to VBOs
  gl.glBindBuffer(GL::GL_ARRAY_BUFFER, posVboId)
  gl.glBufferData(
    GL::GL_ARRAY_BUFFER,
    Float::BYTES * positions.length,
    pos_buffer, GL::GL_DYNAMIC_DRAW
  )
  gl.glVertexAttribPointer(posLoc, 4, GL::GL_FLOAT, false, 4 * Float::BYTES, 0)
  gl.glBindBuffer(GL::GL_ARRAY_BUFFER, colorVboId)
  gl.glBufferData(
    GL::GL_ARRAY_BUFFER,
    Float::BYTES * colors.length,
    color_buffer,
    GL::GL_DYNAMIC_DRAW
  )
  gl.glVertexAttribPointer(colorLoc, 4, GL::GL_FLOAT, false, 4 * Float::BYTES, 0)
  gl.glBindBuffer(GL::GL_ARRAY_BUFFER, 0)
  # Draw the triangle elements
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId)
  gl.glBufferData(
    PGL.ELEMENT_ARRAY_BUFFER,
    Integer::BYTES * indices.length,
    index_buffer,
    GL::GL_DYNAMIC_DRAW
  )
  gl.glDrawElements(PGL.TRIANGLES, indices.length, GL::GL_UNSIGNED_INT, 0)
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0)
  gl.glDisableVertexAttribArray(posLoc)
  gl.glDisableVertexAttribArray(colorLoc)
  shader.unbind
  endPGL
  @angle += 0.01
end

def update_geometry
  # Vertex 1
  chalf_pi = cos(HALF_PI)
  shalf_pi = sin(HALF_PI)
  positions[0] = -200
  positions[1] = -200
  positions[2] = 0
  positions[3] = 1
  colors[0] = 1.0
  colors[1] = 0.0
  colors[2] = 0.0
  colors[3] = 1.0
  # Vertex 2
  positions[4] = +200
  positions[5] = -200
  positions[6] = 0
  positions[7] = 1
  colors[4] = 1.0
  colors[5] = 1.0
  colors[6] = 0.0
  colors[7] = 1.0
  # Vertex 3
  positions[8] = -200
  positions[9] = +200
  positions[10] = 0
  positions[11] = 1
  colors[8] = 0.0
  colors[9] = 1.0
  colors[10] = 0.0
  colors[11] = 1.0
  # Vertex 4
  positions[12] = +200
  positions[13] = +200
  positions[14] = 0
  positions[15] = 1
  colors[12] = 0.0
  colors[13] = 1.0
  colors[14] = 1.0
  colors[15] = 1.0
  # Vertex 5
  positions[16] = -200
  positions[17] = -200 * chalf_pi
  positions[18] = -200 * shalf_pi
  positions[19] = 1
  colors[16] = 0.0
  colors[17] = 0.0
  colors[18] = 1.0
  colors[19] = 1.0
  # Vertex 6
  positions[20] = +200
  positions[21] = -200 * chalf_pi
  positions[22] = -200 * shalf_pi
  positions[23] = 1
  colors[20] = 1.0
  colors[21] = 0.0
  colors[22] = 1.0
  colors[23] = 1.0
  # Vertex 7
  positions[24] = -200
  positions[25] = +200 * chalf_pi
  positions[26] = +200 * shalf_pi
  positions[27] = 1
  colors[24] = 0.0
  colors[25] = 0.0
  colors[26] = 0.0
  colors[27] = 1.0
  # Vertex 8
  positions[28] = +200
  positions[29] = +200 * chalf_pi
  positions[30] = +200 * shalf_pi
  positions[31] = 1
  colors[28] = 1.0
  colors[29] = 1.0
  colors[30] = 1.1
  colors[31] = 1.0
  # Triangle 1
  indices[0] = 0
  indices[1] = 1
  indices[2] = 2
  # Triangle 2
  indices[3] = 2
  indices[4] = 3
  indices[5] = 1
  # Triangle 3
  indices[6] = 4
  indices[7] = 5
  indices[8] = 6
  # Triangle 4
  indices[9] = 6
  indices[10] = 7
  indices[11] = 5
  pos_buffer.rewind
  pos_buffer.put(positions.to_java(:float))
  pos_buffer.rewind
  color_buffer.rewind
  color_buffer.put(colors.to_java(:float))
  color_buffer.rewind
  index_buffer.rewind
  index_buffer.put(indices.to_java(:int))
  index_buffer.rewind
end

def allocate_direct_float_buffer(n)
  ByteBuffer.allocateDirect(
    n * Float::BYTES
  ).order(ByteOrder.nativeOrder).asFloatBuffer
end

def allocate_direct_int_buffer(n)
  ByteBuffer.allocateDirect(
    n * Integer::BYTES
  ).order(ByteOrder.nativeOrder).asIntBuffer
end
