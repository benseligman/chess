require "./piece"

class Board
  def initialize
    @rows = Array.new(8) { Array.new(8) { " " } }
  end

  def [](i, j)
    @rows[i][j]
  end

  def []=(i, j, piece)
    @rows[i][j] = piece
    piece.position = [i, j]
  end

  def empty?(i, j)
    !self[i, j].is_a?(Piece)
  end

  def valid?(move, color)
    return false unless move.all? { |el| el.between?(0, 7) }
    (empty?(*move) || (self[*move].color != color)) ? true : false
  end

  def to_s
    @rows.map do |row|
      row.join("|")
    end.join("\n-----------------\n")
  end
end

@@b = Board.new
@@k = King.new(@@b, :black)
@@b[0, 0] = @@k

