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

  def to_s
    @rows.map do |row|
      row.join("|")
    end.join("\n-----------------\n")
  end
end