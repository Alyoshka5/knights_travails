class Chessboard
    def initialize
        @coord_nodes = []
        build_board()
        @root = @coord_nodes[0]
        #p @root
        @checked = []
    end

    private
    def build_board
        for row in 1..8
            for col in 1..8
                coord_node = find([row, col])
                if coord_node.nil?
                    coord_node = CoordinateNode.new([row, col])
                    @coord_nodes << coord_node
                end
                
                child_coords = get_child_coords(coord_node.coordinate)
                add_child_coords(coord_node, child_coords)
            end
        end
    end
    
    def add_child_coords(coord_node, child_coords)
        child_coords.each do |child_coord|
            child_coord_node = find(child_coord)
            if child_coord_node.nil?
                child_coord_node = CoordinateNode.new(child_coord)
                @coord_nodes << child_coord_node
            end
            coord_node.child_coords << child_coord_node
        end
    end
    
    def get_child_coords(coordinate)
        child_coords = []
        moves = [1, 2, -1, -2]
        for i in moves
            for j in moves
                new_row = coordinate[0]+i
                new_col = coordinate[1]+j
                next if i.abs == j.abs || new_row > 8 || new_row < 1 || new_col > 8 || new_col < 1
                child_coords << [coordinate[0]+i, coordinate[1]+j]
            end
        end
        child_coords
    end
    
    public
    def find(find_coord)
        @coord_nodes.each {|coord_node| return coord_node if coord_node.coordinate == find_coord}
        nil  # coordinate not found
    end

    def find_path3(current_node, end_node, start_node, path = [])
        if current_node == end_node
            # path << end_node.coordinate
            return end_node.distance_to
        elsif current_node == start_node
            current_node.distance_to = 0
        end
        
        @checked << current_node
        closest_node = nil
        current_node.child_coords.each do |child_node|
            next if @checked.include?(current_node)
            if child_node == end_node
                puts 'e'
                child_node.distance_to = end_node.distance_to + 1
            end
            if child_node.distance_to > current_node.distance_to + 1
                child_node.distance_to = current_node.distance_to + 1
            end
            if closest_node.nil? || child_node.distance_to < closest_node.distance_to
                closest_node = child_node
            end
        end
        #return end_node if closest_node == nil
        return find_path(closest_node, end_node, start_node, path) unless closest_node == nil
    end

    def find_path(current_node, end_node, path = [], checked = [])
        if current_node == end_node
            path.unshift(current_node.coordinate)
            return path
        end

        checked << current_node
        counter = 0
        shortest_path = Float::INFINITY
        current_node.child_coords.each do |child_node|
            next if checked.include?(child_node)
            counter += 1
            move = find_path(child_node, end_node, path, checked)
            if move[-1] == end_node.coordinate && move.length < shortest_path
                path = move
                p path
                return
                shortest_path = path.length
            end
        end
        path.unshift(current_node.coordinate)
        return path
    end
end

class CoordinateNode
    attr_accessor :child_coords, :distance_to
    attr_reader :coordinate
    def initialize(coordinate)
        @coordinate = coordinate
        @child_coords = []
        @distance_to = Float::INFINITY
    end
end

board = Chessboard.new
first = board.find([1, 1])
second = board.find([4, 4])
result = board.find_path(first, second, first)
p result