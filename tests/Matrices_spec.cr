# crystal spec tests/Matrices_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"

describe Tracer::Matrix do
  describe "constructors" do
    it "2x2 ctor" do
      m2 = Tracer::M2x2.new({1.0, 0.1}, {3.28, 7.54})
      m2.cell[0][0].should be_close(1.00, Tracer::EPSILON)
      m2.cell[0][1].should be_close(0.10, Tracer::EPSILON)
      m2.cell[1][0].should be_close(3.28, Tracer::EPSILON)
      m2.cell[1][1].should be_close(7.54, Tracer::EPSILON)
    end

    it "3x3 ctor" do
      m3 = Tracer::M3x3.new({1.0, -2.0, 3.0}, {0.25, 0.50, 0.75}, {-8.0, -16.0, -32.0})
      m3.cell[0][0].should be_close( 1.00, Tracer::EPSILON)
      m3.cell[0][1].should be_close(-2.00, Tracer::EPSILON)
      m3.cell[0][2].should be_close( 3.00, Tracer::EPSILON)
      m3.cell[1][0].should be_close( 0.25, Tracer::EPSILON)
      m3.cell[1][1].should be_close( 0.50, Tracer::EPSILON)
      m3.cell[1][2].should be_close( 0.75, Tracer::EPSILON)
      m3.cell[2][0].should be_close(- 8.0, Tracer::EPSILON)
      m3.cell[2][1].should be_close(-16.0, Tracer::EPSILON)
      m3.cell[2][2].should be_close(-32.0, Tracer::EPSILON)
    end

    it "4x4 ctor" do
      m4 = Tracer::M4x4.new({1.0, -2.0, 3.0, 0.11}, {0.25, 0.50, 0.75, 0.22}, {-8.0, -16.0, -32.0, 0.33}, { 86.0, 75.0, 309.0, 0.44 })
      m4.cell[0][0].should be_close(   1.00, Tracer::EPSILON)
      m4.cell[0][1].should be_close(-  2.00, Tracer::EPSILON)
      m4.cell[0][2].should be_close(   3.00, Tracer::EPSILON)
      m4.cell[0][3].should be_close(   0.11, Tracer::EPSILON)
      m4.cell[1][0].should be_close(   0.25, Tracer::EPSILON)
      m4.cell[1][1].should be_close(   0.50, Tracer::EPSILON)
      m4.cell[1][2].should be_close(   0.75, Tracer::EPSILON)
      m4.cell[1][3].should be_close(   0.22, Tracer::EPSILON)
      m4.cell[2][0].should be_close(-  8.00, Tracer::EPSILON)
      m4.cell[2][1].should be_close(- 16.00, Tracer::EPSILON)
      m4.cell[2][2].should be_close(- 32.00, Tracer::EPSILON)
      m4.cell[2][3].should be_close(   0.33, Tracer::EPSILON)
      m4.cell[3][0].should be_close(  86.00, Tracer::EPSILON)
      m4.cell[3][1].should be_close(  75.00, Tracer::EPSILON)
      m4.cell[3][2].should be_close( 309.00, Tracer::EPSILON)
      m4.cell[3][3].should be_close(   0.44, Tracer::EPSILON)
    end
  end

  describe "equality" do
    it "size match required for equality" do
      m3 = Tracer::M3x3.identity
      m4 = Tracer::M4x4.identity
      (m3 == m4).should be_false
    end

    it "is equal when expected" do
      m3a = Tracer::M3x3.identity
      m3b = Tracer::M3x3.new({ 1.0, 0.0, 0.0 }, { 0.0, 1.0, 0.0 }, { 0.0, 0.0, 1.0 })
      m3c = Tracer::M3x3.new({ 1.0, 0.0, 0.0 }, { 0.0, 1.1, 0.0 }, { 0.0, 0.0, 1.0 })
      (m3a == m3b).should be_true
      (m3a == m3c).should be_false
    end
  end

  describe "multiplication" do
    it "multiplies matrices correctly" do
      m4a = Tracer::M4x4.new(
        {  1.0,  2.0,  3.0,  4.0 },
        {  5.0,  6.0,  7.0,  8.0 },
        {  9.0,  8.0,  7.0,  6.0 },
        {  5.0,  4.0,  3.0,  2.0 }
      )
      m4b = Tracer::M4x4.new(
        { -2.0,  1.0,  2.0,  3.0 },
        {  3.0,  2.0,  1.0, -1.0 },
        {  4.0,  3.0,  6.0,  5.0 },
        {  1.0,  2.0,  7.0,  8.0 }
      )
      m4c = Tracer::M4x4.new(
        {  20.0,  22.0,  50.0,  48.0 },
        {  44.0,  54.0, 114.0, 108.0 },
        {  40.0,  58.0, 110.0, 102.0 },
        {  16.0,  26.0,  46.0,  42.0 }
      )

      mult = m4a * m4b
      (mult == m4a).should be_false
      (mult == m4b).should be_false

      # see which cells are mismatches
      (0..3).each do |row|
        (0..3).each do |col|
          mult.cell[row][col].should be_close(m4c.cell[row][col], Tracer::EPSILON)
        end
      end
      (mult == m4c).should be_true
    end

    it "multiplies tuples/vectors correctly" do
      m4 = Tracer::M4x4.new(
        {  1.0,  2.0,  3.0,  4.0 },
        {  2.0,  4.0,  4.0,  2.0 },
        {  8.0,  6.0,  4.0,  1.0 },
        {  0.0,  0.0,  0.0,  1.0 }
      )
      t4a : Tuple(Float64, Float64, Float64, Float64) = { 1.0, 2.0, 3.0, 1.0 }
      v4a = Tracer::V4.new t4a[0], t4a[1], t4a[2], t4a[3]

      t4b = m4 * t4a
      v4b = m4 * v4a

      expected : Tuple(Float64, Float64, Float64, Float64) = { 18.0, 24.0, 33.0, 1.0 }
      (0..3).each do |index|
        t4b[index].should be_close(expected[index], Tracer::EPSILON)
      end
      v4b.x.should be_close(expected[0], Tracer::EPSILON)
      v4b.y.should be_close(expected[1], Tracer::EPSILON)
      v4b.z.should be_close(expected[2], Tracer::EPSILON)
      v4b.w.should be_close(expected[3], Tracer::EPSILON)
    end

    it "multiplies by scalars correctly" do
      m4a = Tracer::M4x4.new(
        {  1.0,  2.0,  3.0,  4.0 },
        {  2.0,  4.0,  4.0,  2.0 },
        {  8.0,  6.0,  4.0,  1.0 },
        {  0.0,  0.0,  0.0,  1.0 }
      )
      m4b = Tracer::M4x4.new(
        {  2.0,  4.0,  6.0,  8.0 },
        {  4.0,  8.0,  8.0,  4.0 },
        { 16.0, 12.0,  8.0,  2.0 },
        {  0.0,  0.0,  0.0,  2.0 }
      )
      m4c = Tracer::M4x4.new(
        {  0.5,  1.0,  1.5,  2.0 },
        {  1.0,  2.0,  2.0,  1.0 },
        {  4.0,  3.0,  2.0,  0.5 },
        {  0.0,  0.0,  0.0,  0.5 }
      )

      ((m4a * 2.0) == m4b).should be_true
      ((m4a / 2.0) == m4c).should be_true
    end
  end

  describe "transpositions" do
    it "transposes correctly" do
      m4a = Tracer::M4x4.new(
        { 0.0, 9.0, 3.0, 0.0 },
        { 9.0, 8.0, 0.0, 8.0 },
        { 1.0, 8.0, 5.0, 3.0 },
        { 0.0, 0.0, 5.0, 8.0 }
      )
      m4b = Tracer::M4x4.new(
        { 0.0, 9.0, 1.0, 0.0 },
        { 9.0, 8.0, 8.0, 0.0 },
        { 3.0, 0.0, 5.0, 5.0 },
        { 0.0, 8.0, 3.0, 8.0 }
      )
      (m4a.transpose == m4b).should be_true

      (Tracer::M4x4.identity.transpose == Tracer::M4x4.identity).should be_true
    end
  end

  describe "submatrices" do
    it "2x2 -> 1x1" do
      m2 = Tracer::M2x2.new( { 5.0, 1.0 }, { -3.0, 27.0 } )
      m2.submatrix(0,0).should be_close(27.0, Tracer::EPSILON)
      m2.submatrix(1,0).should be_close( 1.0, Tracer::EPSILON)
      m2.submatrix(0,1).should be_close(-3.0, Tracer::EPSILON)
      m2.submatrix(1,1).should be_close( 5.0, Tracer::EPSILON)
    end

    it "3x3 -> 2x2" do
      m3 = Tracer::M3x3.new(
        {  1.0, 5.0,  0.0 },
        { -3.0, 2.0,  7.0 },
        {  0.0, 6.0, -3.0 }
      )
      m2 = Tracer::M2x2.new( { -3.0, 2.0 }, { 0.0, 6.0 } )
      (m3.submatrix(0, 2) == m2).should be_true
    end

    it "4x4 -> 3x3" do
      m4 = Tracer::M4x4.new(
        { -6.0, 1.0,  1.0, 6.0 },
        { -8.0, 5.0,  8.0, 6.0 },
        { -1.0, 0.0,  8.0, 2.0 },
        { -7.0, 1.0, -1.0, 1.0 }
      )
      m3 = Tracer::M3x3.new(
        { -6.0,  1.0, 6.0 },
        { -8.0,  8.0, 6.0 },
        { -7.0, -1.0, 1.0 }
      )
      (m4.submatrix(2, 1) == m3).should be_true
    end
  end

  describe "minor/cofactor" do
    it "3x3 minors" do
      m3 = Tracer::M3x3.new(
        { 3.0,  5.0,  0.0 },
        { 2.0, -1.0, -7.0 },
        { 6.0, -1.0,  5.0 }
      )
      m3.minor(1, 0).should be_close(25.0, Tracer::EPSILON)
    end

    it "3x3 cofactors" do
      m3 = Tracer::M3x3.new(
        { 3.0,  5.0,  0.0 },
        { 2.0, -1.0, -7.0 },
        { 6.0, -1.0,  5.0 }
      )
      m3.minor(0, 0).should    be_close(-12.0, Tracer::EPSILON)
      m3.cofactor(0, 0).should be_close(-12.0, Tracer::EPSILON)
      m3.minor(1, 0).should    be_close( 25.0, Tracer::EPSILON)
      m3.cofactor(1, 0).should be_close(-25.0, Tracer::EPSILON)
    end
  end

  describe "determinants" do
    it "determines a 2x2 determinant" do
      m2 = Tracer::M2x2.new( { 1.0, 5.0 }, { -3.0, 2.0 } )
      m2.determinant.should be_close(17.0, Tracer::EPSILON)
    end

    it "determines a 3x3 determinant" do
      m3 = Tracer::M3x3.new(
        {  1.0, 2.0,  6.0 },
        { -5.0, 8.0, -4.0 },
        {  2.0, 6.0,  4.0 }
      )
      m3.cofactor(0,0).should be_close(  56.0, Tracer::EPSILON)
      m3.cofactor(0,1).should be_close(  12.0, Tracer::EPSILON)
      m3.cofactor(0,2).should be_close(- 46.0, Tracer::EPSILON)
      m3.determinant.should   be_close(-196.0, Tracer::EPSILON)
    end

    it "determines a 4x4 determinant" do
      m4 = Tracer::M4x4.new(
        { -2.0, -8.0,  3.0,  5.0 },
        { -3.0,  1.0,  7.0,  3.0 },
        {  1.0,  2.0, -9.0,  6.0 },
        { -6.0,  7.0,  7.0, -9.0 }
      )
      m4.cofactor(0,0).should be_close(  690.0, Tracer::EPSILON)
      m4.cofactor(0,1).should be_close(  447.0, Tracer::EPSILON)
      m4.cofactor(0,2).should be_close(  210.0, Tracer::EPSILON)
      m4.cofactor(0,3).should be_close(   51.0, Tracer::EPSILON)
      m4.determinant.should   be_close(-4071.0, Tracer::EPSILON)
    end
  end

  describe "inversions" do
    it "correctly determines 4x4 inversions" do
      m4a_orig = Tracer::M4x4.new(
        { -5.0,  2.0,  6.0, -8.0 },
        {  1.0, -5.0,  1.0,  8.0 },
        {  7.0,  7.0, -6.0, -7.0 },
        {  1.0, -3.0,  7.0,  4.0 }
      )
      m4a_inv = Tracer::M4x4.new(
        {  0.21805,  0.45113,  0.24060, -0.04511 },
        { -0.80827, -1.45677, -0.44361,  0.52068 },
        { -0.07895, -0.22368, -0.05263,  0.19737 },
        { -0.52256, -0.81391, -0.30075,  0.30639 }
      )
      m4a_op = m4a_orig.inverse
      m4a_orig.determinant.should   be_close( 532.0, Tracer::EPSILON)
      m4a_orig.cofactor(2,3).should be_close(-160.0, Tracer::EPSILON)
      m4a_orig.cofactor(3,2).should be_close( 105.0, Tracer::EPSILON)
      m4a_op.cell[3][2].should be_close(-160.0/532.0, Tracer::EPSILON)
      m4a_op.cell[2][3].should be_close( 105.0/532.0, Tracer::EPSILON)
      (0..3).each do |row|
        (0..3).each do |col|
          m4a_op.cell[row][col].should be_close(m4a_inv.cell[row][col], Tracer::EPSILON)
        end
      end

      m4b_orig = Tracer::M4x4.new(
        {  8.0, -5.0,  9.0,  2.0 },
        {  7.0,  5.0,  6.0,  1.0 },
        { -6.0,  0.0,  9.0,  6.0 },
        { -3.0,  0.0, -9.0, -4.0 }
      )
      m4b_inv = Tracer::M4x4.new(
        { -0.15385, -0.15385, -0.28205, -0.53846 },
        { -0.07692,  0.12308,  0.02564,  0.03077 },
        {  0.35897,  0.35897,  0.43590,  0.92308 },
        { -0.69231, -0.69231, -0.76923, -1.92308 }
      )
      m4b_op = m4b_orig.inverse
      (0..3).each do |row|
        (0..3).each do |col|
          m4b_op.cell[row][col].should be_close(m4b_inv.cell[row][col], Tracer::EPSILON)
        end
      end

      m4c_orig = Tracer::M4x4.new(
        {  9.0,  3.0,  0.0,  9.0 },
        { -5.0, -2.0, -6.0, -3.0 },
        { -4.0,  9.0,  6.0,  4.0 },
        { -7.0,  6.0,  6.0,  2.0 }
      )
      m4c_inv = Tracer::M4x4.new(
        { -0.04074, -0.07778,  0.14444, -0.22222 },
        { -0.07778,  0.03333,  0.36667, -0.33333 },
        { -0.02901, -0.14630, -0.10926,  0.12963 },
        {  0.17778,  0.06667, -0.26667,  0.33333 }
      )
      m4c_op = m4c_orig.inverse
      (0..3).each do |row|
        (0..3).each do |col|
          m4c_op.cell[row][col].should be_close(m4c_inv.cell[row][col], Tracer::EPSILON)
        end
      end
    end

    it "can invert a multiplication" do
      m4a = Tracer::M4x4.new(
        {  3.0, -9.0,  7.0,  3.0 },
        {  3.0, -8.0,  2.0, -9.0 },
        { -4.0,  4.0,  4.0,  1.0 },
        { -6.0,  5.0, -1.0,  1.0 }
      )
      m4b = Tracer::M4x4.new(
        {  8.0,  2.0,  2.0,  2.0 },
        {  3.0, -1.0,  7.0,  0.0 },
        {  7.0,  0.0,  5.0,  4.0 },
        {  6.0, -2.0,  0.0,  5.0 }
      )
      m4c = m4a * m4b

      m4a_im = m4c * m4b.inverse
      (0..3).each do |row|
        (0..3).each do |col|
          m4a_im.cell[row][col].should be_close(m4a.cell[row][col], Tracer::EPSILON)
        end
      end
      (m4a_im == m4a).should be_true
    end
  end

  describe "translations" do
    it "can translate a point" do
      pt_origin = Tracer::Point.new -3.0, 4.0, 5.0
      pt_xlated = Tracer::M4x4.translation(5.0, -3.0, 2.0) * pt_origin
      (pt_xlated == Tracer::Point.new(2.0, 1.0, 7.0)).should be_true
    end

    it "can untranslate a point" do
      pt_origin   = Tracer::Point.new -3.0, 4.0, 5.0
      translation = Tracer::M4x4.translation 5.0, -3.0, 2.0
      untranslate = translation.inverse
      pt_xlated   = translation * pt_origin
      pt_unxlated = untranslate * pt_xlated
      (pt_origin == pt_unxlated).should be_true
    end

    it "doesn't translate vectors" do
      v_origin = Tracer::Vector.new -3.0, 4.0, 5.0
      xlation  = Tracer::M4x4.translation 5.0, -3.0, 2.0
      v_xlated = xlation * v_origin
      (v_xlated == v_origin).should be_true
    end
  end

  describe "scaling" do
    it "scales points" do
      scale = Tracer::M4x4.scale 2.0, 3.0, 4.0
      point = Tracer::Point.new -4.0, 6.0, 8.0
      scaled = scale * point
      (scaled == Tracer::Point.new(-8.0, 18.0, 32.0)).should be_true
    end

    it "scales vectors" do
      scale = Tracer::M4x4.scale 2.0, 3.0, 4.0
      vectr = Tracer::Vector.new -4.0, 6.0, 8.0
      scaled = scale * vectr
      (scaled == Tracer::Vector.new(-8.0, 18.0, 32.0)).should be_true
    end

    it "can uniformly scale" do
      scale = Tracer::M4x4.scale 3.0
      vectr = Tracer::Vector.new -4.0, 6.0, 8.0
      scaled = scale * vectr
      (scaled == Tracer::Vector.new(-12.0, 18.0, 24.0)).should be_true
    end

    it "can scale by an inverse" do
      scale = Tracer::M4x4.scale 2.0, 3.0, 4.0
      invscale = scale.inverse # -> scale(1/2, 1/3, 1/4)
      vect_orig = Tracer::Vector.new -4.0, 6.0, 8.0
      ((invscale * vect_orig) == Tracer::Vector.new(-2.0, 2.0, 2.0)).should be_true
    end
  end

  describe "rotations" do
    it "rotates on x axis" do
      point     = Tracer::Point.new 0.0, 1.0, 0.0
      eighth_x  = Tracer::M4x4.rotation_x Math::TAU / 8.0
      quarter_x = Tracer::M4x4.rotation_x Math::TAU / 4.0
      ((eighth_x  * point) == Tracer::Point.new(0.0, Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0)).should be_true
      ((quarter_x * point) == Tracer::Point.new(0.0, 0.0, 1.0)).should be_true
    end

    it "rotates on y axis" do
      point     = Tracer::Point.new 0.0, 0.0, 1.0
      eighth_y  = Tracer::M4x4.rotation_y Math::TAU / 8.0
      quarter_y = Tracer::M4x4.rotation_y Math::TAU / 4.0
      ((eighth_y  * point) == Tracer::Point.new(Math.sqrt(2.0)/2.0, 0.0, Math.sqrt(2.0)/2.0)).should be_true
      ((quarter_y * point) == Tracer::Point.new(1.0, 0.0, 0.0)).should be_true
    end

    it "rotates on z axis" do
      point     = Tracer::Point.new 0.0, 1.0, 0.0
      eighth_z  = Tracer::M4x4.rotation_z Math::TAU / 8.0
      quarter_z = Tracer::M4x4.rotation_z Math::TAU / 4.0
      ((eighth_z  * point) == Tracer::Point.new(-Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0, 0.0)).should be_true
      ((quarter_z * point) == Tracer::Point.new(-1.0, 0.0, 0.0)).should be_true
    end
  end

  describe "shearing" do
    it "shears correctly" do
      point = Tracer::Point.new 2.0, 3.0, 4.0

      shear = Tracer::M4x4.shear 1.0, 0.0, 0.0, 0.0, 0.0, 0.0
      ((shear * point) == Tracer::Point.new(5.0, 3.0, 4.0)).should be_true

      shear = Tracer::M4x4.shear 0.0, 1.0, 0.0, 0.0, 0.0, 0.0
      ((shear * point) == Tracer::Point.new(6.0, 3.0, 4.0)).should be_true

      shear = Tracer::M4x4.shear 0.0, 0.0, 1.0, 0.0, 0.0, 0.0
      ((shear * point) == Tracer::Point.new(2.0, 5.0, 4.0)).should be_true

      shear = Tracer::M4x4.shear 0.0, 0.0, 0.0, 1.0, 0.0, 0.0
      ((shear * point) == Tracer::Point.new(2.0, 7.0, 4.0)).should be_true

      shear = Tracer::M4x4.shear 0.0, 0.0, 0.0, 0.0, 1.0, 0.0
      ((shear * point) == Tracer::Point.new(2.0, 3.0, 6.0)).should be_true

      shear = Tracer::M4x4.shear 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
      ((shear * point) == Tracer::Point.new(2.0, 3.0, 7.0)).should be_true
    end
  end

  describe "chained transformations" do
    it "chaining test" do
      point       = Tracer::Point.new 1.0, 0.0, 1.0
      rotation    = Tracer::M4x4.rotation_x Math::TAU / 4.0
      scale       = Tracer::M4x4.scale 5.0
      translation = Tracer::M4x4.translation 10.0, 5.0, 7.0

      p2 = rotation * point
      (p2 == Tracer::Point.new(1.0, -1.0, 0.0)).should be_true

      p3 = scale * p2
      (p3 == Tracer::Point.new(5.0, -5.0, 0.0)).should be_true

      p4 = translation * p3
      (p4 == Tracer::Point.new(15.0, 0.0, 7.0)).should be_true

      # when combining AOT, must be in reverse order
      px = (translation * scale * rotation) * point
      (px == p4).should be_true

      perr = (rotation * scale * translation) * point
      (perr == p4).should be_false
    end
  end

  describe "view transformations" do
    it "returns the default view transformation" do
      t = Tracer::M4x4.viewTransform(
        Tracer::Point.new(0.0, 0.0, 0.0),
        Tracer::Point.new(0.0, 0.0, -1.0),
        Tracer::Vector.new(0.0, 1.0, 0.0)
      )
      (t == Tracer::M4x4.identity).should be_true
    end

    it "returns view transform in positive z" do
      t = Tracer::M4x4.viewTransform(
        Tracer::Point.new(0.0, 0.0, 0.0),
        Tracer::Point.new(0.0, 0.0, 1.0),
        Tracer::Vector.new(0.0, 1.0, 0.0)
      )
      (t == Tracer::M4x4.scale(-1.0, 1.0, -1.0)).should be_true
    end

    it "returns translated view transform" do
      t = Tracer::M4x4.viewTransform(
        Tracer::Point.new(0.0, 0.0, 8.0),
        Tracer::Point.new(0.0, 0.0, 0.0),
        Tracer::Vector.new(0.0, 1.0, 0.0)
      )
      (t == Tracer::M4x4.translation(0.0, 0.0, -8.0)).should be_true
    end

    it "returns an arbitrary view transform" do
      t = Tracer::M4x4.viewTransform(
        Tracer::Point.new(1.0, 3.0, 2.0),
        Tracer::Point.new(4.0, -2.0, 8.0),
        Tracer::Vector.new(1.0, 1.0, 0.0)
      )
      compare = Tracer::M4x4.new(
        { -0.50709, 0.50709,  0.67612, -2.36643 },
        {  0.76772, 0.60609,  0.12122, -2.82843 },
        { -0.35857, 0.59761, -0.71714,  0.00000 },
        {  0.00000, 0.00000,  0.00000,  1.00000 },
      )
      (t == compare).should be_true
    end
  end
end
