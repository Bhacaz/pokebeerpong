# frozen_string_literal: true

class ApplicationController < ActionController::API
  SLACK_TOKEN = 'OYhgYLKfzwrZuLwpl7NEAHne'

  def slack
    return head :forbidden if params['token'] != SLACK_TOKEN

    cmd, param = params['text'].split(' ')
    case cmd
    when 'score'
      username = param.match(/(@.*)/)[0]
      if username
        player = Player.find_or_create_by!(username: username)
        player.scores.create!
        render json: { text: ":tada: #{player.display_name}: *#{player.scores.count}*" }
      else
        render json: { text: 'Use: /pokepong `score @<<user>>``' }
      end
    when 'scoreboard'
      render json: { text: scoreboard(param.presence || 'day') }
    else
      render json: { text: "Valid command:\n \t/pokepong `score @<<user>>`\n \t/pokepong `scoreboard ['day' 'week' 'month' 'year']`" }
    end
  end

  private

  def scoreboard(for_the = 'day')
    icons = %w[
      :first_place_medal:
      :second_place_medal:
      :third_place_medal:
      :four:
      :five
      :six
      :seven:
      :height:
      :nine:
    ]

    scores = Score.for_the(for_the).group_by(&:player)
    scores.transform_values!(&:count)
    scores = scores.group_by(&:second)
    scores.transform_values! { |v| v.map(&:first) }
    scores = scores.sort_by { |v| -v.first }

    p scores
    message_score = ["*Scoreboard: #{Date.current}*"]
    scores.each_with_index do |(score, players), index|
      players.each do |player|
        message_score << "#{icons[index]}\t#{player.display_name} : *#{score}*"
      end
    end
    message_score.join("\n")
  end
end
