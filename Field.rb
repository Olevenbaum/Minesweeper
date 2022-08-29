class Field
    def initialize
        @mine = false
        @number_of_mines_nearby = 0
        @discovered = false
        @flag = false
    end
    def set_mine p_mine
        @mine = p_mine
        if @mine
            @number_of_mines_nearby = nil
        end
    end
    def set_discovered p_discovered
        @discovered = p_discovered
    end
    def set_flag p_flag
        @flag = p_flag
    end
    def increase_number_of_mines_nearby
        if @mine
            @number_of_mines_nearby = nil
        else
            @number_of_mines_nearby += 1
        end
    end
    def get_status
        [@mine, @discovered, @flag]
    end
    def get_number_of_mines_nearby
        @number_of_mines_nearby
    end
end
