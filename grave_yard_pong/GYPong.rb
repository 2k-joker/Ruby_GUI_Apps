require 'gosu' 
include Gosu 

$game_over = false
$game_started = false

class Pong < Window
    def initialize
        super 640, 480, false
        @song = Song.new('load/song.ogg')
        @song_2 = Song.new('load/song_2.ogg')

        @bar_1 = Image.new('load/bar_1.png')
        @bar_2 = Image.new('load/bar_2.png')
        @ball = Image.new('load/ball.png')

        @hit_smp = Sample.new('load/hit.ogg')
        @miss_smp = Sample.new('load/miss.ogg')
        @game_start_smp = Sample.new('load/game_start.ogg')

        @sky = Image.new("load/sky.png")
        @stars = Image.new("load/stars.png")
        @moon = Image.new("load/moon.png")
        @grave = Image.new("load/grave.png")

        @x1 = 20
        @x2 = self.width - @bar_2.width - 20
        @y1 = self.height / 2 - @bar_1.height / 2
        @y2 = self.height / 2 - @bar_2.height / 2
        @ball_x = self.width / 2 - @ball.width
        @ball_y = self.height / 2 - @ball.height
        @moon_x = self.width / 1.5 - 45
        @moon_y = self.height

        @ball_speed = rand(4..9)
        @ball_speed_y = rand(3..5)
        @bar_speed = rand(7..11)

        @left_score = 0
        @right_score = 0

        @score_font = Font.new(28)
        @speed_font = Font.new(24, :bold => true)
        @game_play_font = Font.new(28, :italic => true)
        @game_over_font = Font.new(36)
        @game_start_font = Font.new(24, :bold => true)
        @try_again_font = Font.new(24)
        @credits_font = Font.new(12, :bold => true)
    end

    def update
        self.caption = "Graveyard Pong"

        if $game_started == true and $game_over == false
            @song_2.play(volume = 1)
            @ball_x += @ball_speed
            @ball_y += @ball_speed_y

            if @ball_y <= 0 or @ball_y >= self.height
                @ball_speed_y *= -1
            end

            if @ball_x <= @x1 + @bar_1.width * 2 and @ball_y >= @y1 and @ball_y <= @y1 + @bar_1.height
                @ball_speed *= -1.2
                @ball_speed_y *= 1.1
                @bar_speed *= 1.05
                @hit_smp.play(volume = 0.4)
            end

            if @ball_x >= @x2 - @bar_2.width * 2 and @ball_y >= @y2 and @ball_y <= @y2 + @bar_2.height
                @ball_speed *= -1.3
                @ball_speed_y *= 1.2
                @bar_speed *= 1.05
                @hit_smp.play(volume = 0.4)
            end

            if @ball_speed == 0 and @ball_speed <= rand(4..6)
                @ball_speed += 1
            end

            if @ball_x < @x1 - @bar_1.width
                @miss_smp.play(volume = 0.7)
                @right_score += 1

                @ball_speed = rand(3..9)
                @ball_speed_y = rand(3..5)
                @bar_speed = rand(7..11)
                @ball_x = self.width / 2 - @ball.width
                @ball_y = self.height / 2 - @ball.height
                @y1 = self.height / 2 - @bar_1.height / 2
                @y2 = self.height / 2 - @bar_2.height / 2
            end

            if @ball_x > @x2 + @bar_2.width
                @miss_smp.play(volume = 0.7)
                @left_score += 1

                @ball_speed = rand(-9..-3)
                @ball_speed_y = rand(3..5)
                @bar_speed = rand(7..11)
                @ball_x = self.width / 2 - @ball.width
                @ball_y = self.height / 2 - @ball.height   
                @y1 = self.height / 2 - @bar_1.height / 2
                @y2 = self.height / 2 - @bar_2.height / 2 
            end
        elsif $game_started == true and $game_over == true
            @song.play
            if button_down? KbSpace
                @game_start_smp.play(volume = 0.6)
                $game_over = false
            end

        else
            @song.play
            if button_down? KbTab               
                @game_start_smp.play(volume = 0.6)
                $game_started = true
            end
        end

        if $game_started == true
            @y2 -= @bar_speed if button_down? KbUp and @y2 >= -@bar_2.height / 2
            @y2 += @bar_speed if button_down? KbDown and @y2 <= self.height - @bar_2.height / 2
            @y1 -= @bar_speed if button_down? KbA and @y1 >= -@bar_1.height / 2
            @y1 += @bar_speed if button_down? KbZ and @y1 <= self.height - @bar_1.height / 2

            @moon_y -= 0.30
            if @moon_y > self.height / 2 - @moon.height
                @moon_x += 0.075
            else
                @moon_x -= 0.1
            end
            if @moon_y <= -@moon.height
                $game_over = true
                if button_down? KbSpace
                    @x1 = 20
                    @x2 = self.width - @bar_2.width - 20
                    @y1 = self.height / 2 - @bar_1.height / 2
                    @y2 = self.height / 2 - @bar_2.height / 2
                    @ball_x = self.width / 2 - @ball.width
                    @ball_y = self.height / 2 - @ball.height
                    @moon_y = self.height

                    @ball_speed = rand(4..9)
                    @ball_speed_y = rand(3..5)
                    @bar_speed = rand(7..11)

                    @left_score = 0
                    @right_score = 0                 
                    $game_over = false 
                end
            end
        end
    end

    def draw
        if $game_started == false and $game_over == false
            @game_start_font.draw_text("Press TAB to start game!", 190, 35, 5)
            @game_play_font.draw_text("Left use A-Z | Right use Up-Down", 125, 80, 5)

        elsif $game_started == true and $game_over == false
            @score_font.draw("#{@left_score}||#{@right_score}", self.width / 2 - 20, 35, 5)
            @speed_font.draw_text("speed: #{fps}", self.width / 2 - 40, 15, 5, 0.7, 0.7, 0xff_2A8AE2)
            
            @ball.draw(@ball_x, @ball_y, 1)
            @bar_1.draw(@x1, @y1, 1)
            @bar_2.draw(@x2, @y2, 1)
            @moon.draw(@moon_x, @moon_y, -1)
        else
            @game_over_font.draw("GAME OVER!", 215, 35, 5)
            
            @score_font.draw("Left Wins!", 260, 80, 5) if @left_score > @right_score
            @score_font.draw("Right Wins!", 255, 80, 5) if @right_score > @left_score
            @score_font.draw("It's a tie!", 265, 80, 5) if @left_score == @right_score

            @try_again_font.draw_text("Press SPACEBAR to play once more!", 135, 135, 1)
        end

        @credits_font.draw_text("Code: SavageHolycow and Khalil Kum; Graphics: Ptc248; Music: Kevin MacLeod", 220, self.height - 18, 1, 1, 1, Color::GRAY)
        @sky.draw(0, 0, -3)
        @stars.draw(0, 0, -2)
        @grave.draw(0, self.height - @grave.height, 0)
        
    end
end

Pong.new.show