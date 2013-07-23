load "./piece.rb"

class Board
  def initialize
    @rows = Array.new(8) { Array.new(8) { " " } }
  end

  def [](i, j)
    @rows[i][j]
  end

  def []=(i, j, piece)
    @rows[i][j] = piece
    piece.position = [i, j] unless self.empty?(i, j)
  end

  def empty?(i, j)
    return false unless on_board?(i, j)
    !self[i, j].is_a?(Piece)
  end

  def on_board?(i, j)
    pos = [i, j]
    pos.all? { |el| el.between?(0, 7) }
  end

  def move(origin, destination)
    piece = self[*origin]
    possible_moves = piece.possible_moves

    if possible_moves.include? (destination)
      self[*destination] = piece
      self[*origin] = " "
    end
    #TODO: harden code
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
@@r = Rook.new(@@b, :white)
@@b[0, 7] = @@r



