module Tracer
  class Matrix
    def self.size : UInt8
      0
    end

    def ==(other : Matrix) : Bool
      return false unless self.class.size == other.class.size

      upper = self.class.size
      (0...upper).each do |row|
        (0...upper).each do |col|
          return false unless Tracer.feq(@cell[row][col], other.cell[row][col])
        end
      end  
      true
    end

    def to_s() : String
      result = ""

      upper = self.class.size - 1
      (0..upper).each do |row|
        line : String = ""
        (0..upper).each do |col|
          line += "#{@cell[row][col]}#{(col != upper) ? ", " : ""}"
        end
        result += "[ #{line} ]#{(row != upper) ? "\n" : ""}"
      end

      result
    end
  end

  class M2x2 < Matrix
    property cell : Tuple(Tuple(Float64, Float64), Tuple(Float64, Float64))

    def initialize(c00 : Float64, c01 : Float64, c10 : Float64, c11 : Float64)
      @cell = {
        { c00, c01 },
        { c10, c11 }
      }
    end

    def initialize(c0 : Tuple(Float64, Float64), c1 : Tuple(Float64, Float64))
      @cell = { c0, c1 }
    end

    def initilize(copy : M2x2)
      @cell = {
        { copy.cell[0][0], copy.cell[0][1] },
        { copy.cell[1][0], copy.cell[1][1] }
      }
    end

    def submatrix(skip_row : UInt64, skip_col : UInt64) : Float64
      @cell[(skip_row > 0.5) ? 0 : 1][(skip_col > 0.5) ? 0 : 1]
    end

    def determinant() : Float64
      (@cell[0][0] * @cell[1][1]) - (@cell[0][1] * @cell[1][0])
    end

    def self.size : UInt8
      2_u8
    end

    def self.identity() : M2x2
      M2x2.new({ 1.0, 0.0 }, { 0.0, 1.0 })
    end
  end

  class M3x3 < Matrix
    property cell : Tuple(Tuple(Float64, Float64, Float64), Tuple(Float64, Float64, Float64), Tuple(Float64, Float64, Float64))

    def initialize(c00 : Float64, c01 : Float64, c02 : Float64, c10 : Float64, c11 : Float64, c12 : Float64, c20 : Float64, c21 : Float64, c22 : Float64)
      @cell = {
        { c00, c01, c02 },
        { c10, c11, c12 },
        { c20, c21, c22 }
      }
    end

    def initialize(c0 : Tuple(Float64, Float64, Float64), c1 : Tuple(Float64, Float64, Float64), c2 : Tuple(Float64, Float64, Float64))
      @cell = { c0, c1, c2 }
    end

    def initilize(copy : M3x3)
      @cell = {
        { copy.cell[0][0], copy.cell[0][1], copy.cell[0][2] },
        { copy.cell[1][0], copy.cell[1][1], copy.cell[1][2] },
        { copy.cell[2][0], copy.cell[2][1], copy.cell[2][2] }
      }
    end

    def submatrix(skip_row : UInt64, skip_col : UInt64) : M2x2
      result_rows : Array(Tuple(Float64, Float64)) = [] of Tuple(Float64, Float64)

      (0..2).each do |row|
        next if row == skip_row
        result_cols : Array(Float64) = [] of Float64
        (0..2).each do |col|
          next if col == skip_col
          result_cols.push @cell[row][col]
        end
        result_rows.push Tuple(Float64, Float64).from(result_cols)
      end

      M2x2.new result_rows[0], result_rows[1]
    end

    def minor(skip_row : UInt64, skip_col : UInt64) : Float64
      self.submatrix(skip_row, skip_col).determinant
    end

    def cofactor(skip_row : UInt64, skip_col : UInt64) : Float64
      minor = self.minor(skip_row, skip_col)
      minor * ((((skip_row + skip_col) & 1) == 1) ? -1.0 : 1.0)
    end

    def determinant() : Float64
      (@cell[0][0] * self.cofactor(0,0)) +
      (@cell[0][1] * self.cofactor(0,1)) +
      (@cell[0][2] * self.cofactor(0,2))
    end

    def self.size : UInt8
      3_u8
    end

    def self.identity() : M3x3
      M3x3.new({ 1.0, 0.0, 0.0 }, { 0.0, 1.0, 0.0 }, { 0.0, 0.0, 1.0 })
    end
  end

  class M4x4 < Matrix
    property cell : Tuple(Tuple(Float64, Float64, Float64, Float64), Tuple(Float64, Float64, Float64, Float64), Tuple(Float64, Float64, Float64, Float64), Tuple(Float64, Float64, Float64, Float64))

    def initialize(c00 : Float64, c01 : Float64, c02 : Float64, c03 : Float64, c10 : Float64, c11 : Float64, c12 : Float64, c13 : Float64, c20 : Float64, c21 : Float64, c22 : Float64, c23 : Float64, c30 : Float64, c31 : Float64, c32 : Float64, c33 : Float64)
      @cell = {
        { c00, c01, c02, c03 },
        { c10, c11, c12, c13 },
        { c20, c21, c22, c23 },
        { c30, c31, c32, c33 }
      }
    end

    def initialize(c0 : Tuple(Float64, Float64, Float64, Float64), c1 : Tuple(Float64, Float64, Float64, Float64), c2 : Tuple(Float64, Float64, Float64, Float64), c3 : Tuple(Float64, Float64, Float64, Float64))
      @cell = { c0, c1, c2, c3 }
    end

    def initialize(copy : M4x4)
      @cell = {
        { copy.cell[0][0], copy.cell[0][1], copy.cell[0][2], copy.cell[0][3] },
        { copy.cell[1][0], copy.cell[1][1], copy.cell[1][2], copy.cell[1][3] },
        { copy.cell[2][0], copy.cell[2][1], copy.cell[2][2], copy.cell[2][3] },
        { copy.cell[3][0], copy.cell[3][1], copy.cell[3][2], copy.cell[3][3] },
      }
    end

    def *(other : M4x4) : M4x4
      cell : Array(Float64) = [] of Float64

      (0..3).each do |result_row|
        (0..3).each do |result_col|
          value : Float64 = 0.0
          (0..3).each do |index|
            value += @cell[result_row][index] * other.cell[index][result_col]
          end
          cell.push value
        end
      end

      M4x4.new(
        { cell[ 0], cell[ 1], cell[ 2], cell[ 3] },
        { cell[ 4], cell[ 5], cell[ 6], cell[ 7] },
        { cell[ 8], cell[ 9], cell[10], cell[11] },
        { cell[12], cell[13], cell[14], cell[15] }
      )
    end

    def *(other : Tuple(Float64, Float64, Float64, Float64)) : Tuple(Float64, Float64, Float64, Float64)
      cell : Array(Float64) = [] of Float64

      (0..3).each do |result_col|
        value : Float64 = 0.0
        (0..3).each do |index|
          value += @cell[result_col][index] * other[index]
        end
        cell.push value
      end

      { cell[0], cell[1], cell[2], cell[3] }
    end

    def *(other : V4) : V4
      result = self * { other.x, other.y, other.z, other.w }
      V4.new result[0], result[1], result[2], result[3]
    end

    def *(scalar : Float64) : M4x4
      rows : Array(Tuple(Float64, Float64, Float64, Float64)) = [] of Tuple(Float64, Float64, Float64, Float64)
      (0..3).each do |row|
        cols : Array(Float64) = [] of Float64
        (0..3).each do |col|
          cols.push @cell[row][col] * scalar
        end
        rows.push Tuple(Float64, Float64, Float64, Float64).from(cols)
      end
      M4x4.new rows[0], rows[1], rows[2], rows[3]
    end

    def /(scalar : Float64) : M4x4
      rows : Array(Tuple(Float64, Float64, Float64, Float64)) = [] of Tuple(Float64, Float64, Float64, Float64)
      (0..3).each do |row|
        cols : Array(Float64) = [] of Float64
        (0..3).each do |col|
          cols.push @cell[row][col] / scalar
        end
        rows.push Tuple(Float64, Float64, Float64, Float64).from(cols)
      end
      M4x4.new rows[0], rows[1], rows[2], rows[3]
    end

    def transpose() : M4x4
      M4x4.new(
        { @cell[0][0], @cell[1][0], @cell[2][0], @cell[3][0] },
        { @cell[0][1], @cell[1][1], @cell[2][1], @cell[3][1] },
        { @cell[0][2], @cell[1][2], @cell[2][2], @cell[3][2] },
        { @cell[0][3], @cell[1][3], @cell[2][3], @cell[3][3] }
      )
    end

    def submatrix(skip_row : UInt64, skip_col : UInt64) : M3x3
      result_rows : Array(Tuple(Float64, Float64, Float64)) = [] of Tuple(Float64, Float64, Float64)

      (0..3).each do |row|
        next if row == skip_row
        result_cols : Array(Float64) = [] of Float64
        (0..3).each do |col|
          next if col == skip_col
          result_cols.push @cell[row][col]
        end
        result_rows.push Tuple(Float64, Float64, Float64).from(result_cols)
      end

      M3x3.new result_rows[0], result_rows[1], result_rows[2]
    end

    def minor(skip_row : UInt64, skip_col : UInt64) : Float64
      self.submatrix(skip_row, skip_col).determinant
    end

    def cofactor(skip_row : UInt64, skip_col : UInt64) : Float64
      minor = self.minor(skip_row, skip_col)
      minor * ((((skip_row + skip_col) & 1) == 1) ? -1.0 : 1.0)
    end

    def determinant() : Float64
      (@cell[0][0] * self.cofactor(0,0)) +
      (@cell[0][1] * self.cofactor(0,1)) +
      (@cell[0][2] * self.cofactor(0,2)) +
      (@cell[0][3] * self.cofactor(0,3))
    end

    def inverse() : M4x4
      det = self.determinant
      return self.class.zero() if det == 0 # not invertable

      # build M4x4 of cofactors
      co_rows : Array(Tuple(Float64, Float64, Float64, Float64)) = [] of Tuple(Float64, Float64, Float64, Float64)
      (0_u64..3_u64).each do |row|
        co_cols : Array(Float64) = [] of Float64
        (0_u64..3_u64).each do |col|
          co_cols.push self.cofactor(row, col)
        end
        co_rows.push Tuple(Float64, Float64, Float64, Float64).from(co_cols)
      end
      cofactors = M4x4.new co_rows[0], co_rows[1], co_rows[2], co_rows[3]

      cofactors.transpose / det
    end

    def self.size : UInt8
      4_u8
    end

    def self.identity() : M4x4
      M4x4.new({ 1.0, 0.0, 0.0, 0.0 }, { 0.0, 1.0, 0.0, 0.0 }, { 0.0, 0.0, 1.0, 0.0 }, { 0.0, 0.0, 0.0, 1.0 })
    end

    def self.zero() : M4x4
      M4x4.new({ 0.0, 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 })
    end

    def self.translation(x : Float64, y : Float64, z : Float64) : M4x4
      M4x4.new({ 1.0, 0.0, 0.0, x }, { 0.0, 1.0, 0.0, y }, { 0.0, 0.0, 1.0, z }, { 0.0, 0.0, 0.0, 1.0 })
    end
    def self.translation(v : V4) : M4x4
      self.translation(v[0], v[1], v[2])
    end

    def self.scale(x : Float64, y : Float64, z : Float64)
      M4x4.new({ x, 0.0, 0.0, 0.0 }, { 0.0, y, 0.0, 0.0 }, { 0.0, 0.0, z, 0.0 }, { 0.0, 0.0, 0.0, 1.0 })
    end
    def self.scale(scale : Float64)
      self.scale scale, scale, scale
    end

    # all rotations are only around the origin point (0,0,0)

    def self.rotation_x(radians : Float64) : M4x4
      cosine = Math.cos(radians)
      sine   = Math.sin(radians)
      M4x4.new({ 1.0, 0.0, 0.0, 0.0 }, { 0.0, cosine, -sine, 0.0 }, { 0.0, sine, cosine, 0.0 }, { 0.0, 0.0, 0.0, 1.0 })
    end

    def self.rotation_y(radians : Float64) : M4x4
      cosine = Math.cos(radians)
      sine   = Math.sin(radians)
      M4x4.new({ cosine, 0.0, sine, 0.0 }, { 0.0, 1.0, 0.0, 0.0 }, { -sine, 0.0, cosine, 0.0 }, { 0.0, 0.0, 0.0, 1.0 })
    end

    def self.rotation_z(radians : Float64) : M4x4
      cosine = Math.cos(radians)
      sine   = Math.sin(radians)
      M4x4.new({ cosine, -sine, 0.0, 0.0 }, { sine, cosine, 0.0, 0.0 }, { 0.0, 0.0, 1.0, 0.0 }, { 0.0, 0.0, 0.0, 1.0 })
    end

    def self.shear(xy : Float64, xz : Float64, yx : Float64, yz : Float64, zx : Float64, zy : Float64) : M4x4
      M4x4.new({ 1.0, xy, xz, 0.0 }, { yx, 1.0, yz, 0.0 }, { zx, zy, 1.0, 0.0 }, { 0.0, 0.0, 0.0, 1.0 })
    end
  end
end
