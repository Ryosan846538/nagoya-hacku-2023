class ApiController < ApplicationController
  def ask

    config = <<~CONFIG
    これからあなたには以上の目標を達成するためのプロセスを考えてもらいます。
    まず大まかに目標達成のプロセスを5つに分けてもらいます。
    この大まかに5つに分けられたプロセスをそれぞれ[Process]と定義します。
    つまり[Process1,Process2,Process3,Process4,Process5]が存在することになります。
    あなたにはJSON形式のプロンプトを書いてもらいます。以下にJSON形式を用意しました。""の内部に適切な文章を埋めてください。ただし埋める文章は最大20文字までとします。

    ＜注意＞
    ChatGPTあなたの返信は以下のJSON形式のみとします。必ず守るようにしてください。

    {
      "title": "",
      "Process":{
        "Process1" : "",
        "Process2" : "",
        "Process3" : "",
        "Process4" : "",
        "Process5" : "",
        "Process1-1" : "",
        "Process1-2" : "",
        "Process1-3" : "",
        "Process1-4" : "",
        "Process1-5" : "",
        "Process2-1" : "",
        "Process2-2" : "",
        "Process2-3" : "",
        "Process2-4" : "",
        "Process2-5" : "",
        "Process3-1" : "",
        "Process3-2" : "",
        "Process3-3" : "",
        "Process3-4" : "",
        "Process3-5" : "",
        "Process4-1" : "",
        "Process4-2" : "",
        "Process4-3" : "",
        "Process4-4" : "",
        "Process4-5" : "",
        "Process5-1" : "",
        "Process5-2" : "",
        "Process5-3" : "",
        "Process5-4" : "",
        "Process5-5" : ""
      }
    }
    CONFIG
    question = params[:question]

    response = generate_story(config, question)

    process = response["Process"]

    mission = Mission.new
    mission.title = response["title"]
    mission.progress = 1
    mission.save

    process.each_value do |value|
      sub = SubMission.new
      sub.mission = mission
      sub.content = value
      sub.save
    end

    render :json => {
      "title": response["title"],
      "response": process,
    }
  end

  def all
    mission = Mission.all
    json_data = {}

    # DB1から目標情報を取得します。
    mission.each do |miso|
      goal_key = "goal#{miso.id}"
      json_data[goal_key] = { "title" => miso.title, "Progress" => {} }

      # DB2からサブミッション情報を取得します。
      sub = SubMission.where(mission_id: miso.id)
      sub.each_with_index do |submi, index|
        if index < 5
          process_key = "Process#{json_data[goal_key]["Progress"].size + 1}"
          json_data[goal_key]["Progress"][process_key] = submi.content          
        else
          process_key = "Process#{(json_data[goal_key]["Progress"].size) / 5}-#{(json_data[goal_key]["Progress"].size) % 5 + 1}"
          json_data[goal_key]["Progress"][process_key] = submi.content
        end
      end
    end

    # 最終的なJSONデータを表示します。
    render :json => JSON.pretty_generate(json_data)
  end

  def generate_story(config, question)

    client = OpenAI::Client.new(access_token: "")

    response = client.chat(
      parameters:{
        model: "gpt-3.5-turbo",
        messages: [
          {role: "system", content: config},
          {role: "user", content: question}
        ],
      }
    )
    json = JSON.parse(response.dig('choices', 0, 'message', 'content'))
    return json
  end
end
