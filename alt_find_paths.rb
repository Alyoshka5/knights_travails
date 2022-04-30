def find_path2(current_node, end_node, path = [], checked = [])
    if current_node == end_node
        path << end_node.coordinate
        return path
    end
    checked << current_node
    counter = 0
    cor = false
    shortest_path = Float::INFINITY
    current_node.child_coords.each do |child_node|
        next if checked.include?(child_node)
        counter += 1
        move = find_path(child_node, end_node, [], checked)
        if !move.nil? && move.length < shortest_path
            path = move
            shortest_path = path.length
        end
    end
    path.unshift(current_node.coordinate)
    return counter == 0 ? nil : path
end

# BREADTH FIRST SEARCH
def find_path(start_node, end_node, queue = [current_node], path = [])
    puts "empty queue" if queue.length == 0
    current_node = queue.shift
    @checked << current_node
    if current_node == end_node
        path.unshift(current_node)
        return path
    end

    current_node.child_coords.each do |child_node|
        queue << child_node unless @checked.include?(child_node)
    end
end