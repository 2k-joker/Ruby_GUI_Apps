require 'gosu'
require_relative 'player'
require_relative 'star'

$game_over = false
$game_started = false

class SpaceRocketFighter < Gosu::Window

    def initialize
        super(640, 400, false)
        self.caption = "Space Rocket Fighter"
        
        @background_image = Gosu::Image.new('assets/space.png', :tileable =>true)
        @song = Gosu::Song.new("assets/song.ogg")
        @intro = Gosu::Song.new("assets/song_2.ogg")
        @player1 = Player.new
        @player2 = Player.new
        @player1.warp(420, 240)
        @player2.warp(220, 240)

        @target_score = 100

        @star_anim = Gosu::Image.load_tiles('assets/star.png', 25, 25)
        @stars = Array.new

        @score_font = Gosu::Font.new(20)
        @welcome_font = Gosu::Font.new(32,:bold => true)
        @text_font = Gosu::Font.new(24)
        @exit_font = Gosu::Font.new(20, :italic => true)
    end

    def update

        if $game_started == true and $game_over == false 

            @song.play(volume = 5)

            if Gosu.button_down? Gosu::KB_LEFT 
                @player1.turn_left
            end
            if Gosu.button_down? Gosu::KB_Z 
                @player2.turn_left
            end
            if Gosu.button_down? Gosu::KB_RIGHT 
                @player1.turn_right
            end
            if Gosu.button_down? Gosu::KB_X 
                @player2.turn_right
            end
            if Gosu.button_down? Gosu::KB_UP 
                @player1.accelerate
            end
            if Gosu.button_down? Gosu::KB_S 
                @player2.accelerate
            end

            @player1.move   
            @player2.move  
            @player1.collect_stars(@stars)
            @player2.collect_stars(@stars)
            
            if rand(100) < 4 and @stars.size < 25
                @stars.push(Star.new(@star_anim))
            end   
            
            if @player1.score == @target_score or @player2.score == @target_score
                $game_over = true
            end
                   
        elsif $game_started == true and $game_over == true

            @intro.play(volume = 1)

            if Gosu.button_down? Gosu::KB_SPACE
                $game_over = false
                @player1.reset_score 
                @player2.reset_score 
            end

        else
            @intro.play(volume = 5)

            if Gosu.button_down? Gosu::KB_SPACE
                $game_started = true 
            end
        end 

    end

    def draw

        if $game_started == false
            @text_font.draw_text("Press SPACE to start", 200, 30, ZOrder::UI)
            @text_font.draw_text("Player 2 use Z, X and S || Player 1 use Left, Right, Up", 50, 70, ZOrder::UI)
            @text_font.draw_text("First to 100 points wins!", 190, 100, ZOrder::UI)
            @welcome_font.draw_text("Welcome to Space Rocket Jam", 100, self.height / 2, ZOrder::UI, 1, 1, 0xff_2A8AE2)
            @exit_font.draw_text("Press ESC to exit game", 220, self.height - 80, ZOrder::UI, 1, 1, Gosu::Color::RED)
        
        elsif $game_started == true and $game_over == false
            @background_image.draw(0, 0, ZOrder::BACKGROUND)
            @player1.draw_first
            @player2.draw_second
            @stars.each {|star| star.draw}
            @score_font.draw_text("Player2: #{@player2.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            @score_font.draw_text("Player1: #{@player1.score}", 520, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

        else
            @text_font.draw_text("Player 2 wins!", 220, 50, ZOrder::UI, 1.5, 1.5, 0xff_2A8AE2) if @player2.score > @player1.score
            @text_font.draw_text("Player 1 wins!", 220, 50, ZOrder::UI, 1.5, 1.5, 0xff_2A8AE2) if @player2.score < @player1.score
            @text_font.draw_text("It's a Tie!", 240, 50, ZOrder::UI, 1.5, 1.5, 0xff_2A8AE2) if @player2.score == @player1.score
            @welcome_font.draw_text("Game Over! Press SPACE to play again", 130, self.height / 2 - 50, ZOrder::UI, 0.7, 0.7, 0xff_ffffff)
            @exit_font.draw_text("Press ESC to exit game", 220, self.height - 80, ZOrder::UI, 1, 1, Gosu::Color::RED)
        end

    end
    
    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end

    def set_limit(value)
        @time_limit = value
    end

end

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

SpaceRocketFighter.new.show