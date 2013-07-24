load "./piece.rb"

#TODO: Add #check, #checkmate, #populate_board
class Board
  def initialize
    @rows = Array.new(8) { Array.new(8) { nil } }
  end

  def [](i, j)
    @rows[i][j]
  end

  def dup
    dupped_board = Board.new
    self.all_pieces.each do |piece|
      dupped_board[*piece.position] = piece.dup
    end

    dupped_board
  end

  def empty?(i, j)
    raise IndexError "Off Board!" unless on_board?(i, j)
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
      move!(origin, destination)
    end
    #TODO: harden code
  end

  def move!(origin, destination)
    piece = self[*origin]

    self[*destination] = piece
    self[*origin] = nil
  end

  def opposite_color(color)
    color == :white ? :black : :white
  end

  def king_position(color)
    king = self.team_pieces(color).find { |piece| piece.is_a?(King) }
    king.position
  end

  def team_pieces(color)
    self.all_pieces.select { |piece| piece.color == color }
  end

  def all_pieces
    @rows.flatten.compact
  end

  def team_moves(color)
    team_moves = team_pieces(color).map { |piece| piece.possible_moves }
    team_moves.flatten(1)
  end

  def check?(color)
    opposing_moves = self.team_moves(opposite_color(color))
    opposing_moves.include?(king_position(color))
  end

  def to_s
    @rows.map do |row|
      row.join("|")
    end.join("\n-----------------\n")
  end

  #private

  def []=(i, j, piece)
    @rows[i][j] = piece
    piece.position = [i, j] unless piece.nil?
  end

  def set_pieces
    self.[0, 0] = Rook.new(self)
  end

end

$b = Board.new

$k = King.new($b, :black)
$r = Rook.new($b, :white)
$p = Pawn.new($b, :white)

$b[0, 0] = $k
$b[0, 7] = $r
$b[6, 0] = $p

p $b.team_moves(:black)



