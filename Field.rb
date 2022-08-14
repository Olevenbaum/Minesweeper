class Field
    def initialize
        @mine = false
        @number_of_mines_nearby = 0
        @discovered = true
        @flag = false
    end
    def get_status
        [@mine, @discovered, @flag]
    end
    def get_number_of_mines_nearby
        @number_of_mines_nearby
    end
    def set_mine p_mine
        if p_mine == nil
            @mine = !@mine
        else
            @mine = p_mine
        end
        if @mine
            @number_of_mines_nearby = nil
        end
    end
    def increase_number_of_mines_nearby
        if @mine
            @number_of_mines_nearby = nil
        else
            @number_of_mines_nearby += 1
        end
    end
    def set_discovered p_discovered
        if p_discovered == nil
            @discovered = !@discovered
        else
            @discovered = p_discovered
        end
    end
    def set_flag p_flag
        if  p_flag == nil
            @flag = !@flag
        else
            @flag = p_flag
        end
    end
end
