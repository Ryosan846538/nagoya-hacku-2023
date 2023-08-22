class ApiController < ApplicationController
  def ask

    config = <<~CONFIG
    これからあなたには以上の目標を達成するためのプロセスを考えてもらいます。
    まず大まかに目標達成のプロセスを5つに分けてもらいます。
    この大まかに5つに分けられたプロセスをそれぞれ[Process]と定義します。
    つまり[Process1,Process2,Process3,Process4,Process5]が存在することになります。
    
    さらに、[Process]を達成するためのプロセスを考えてもらいます。
    まず[Process]の達成のためのプロセスを5つに分けてもらいます。
    例えばProcess1を達成するための5つのプロセスは[Process1_1,Process1_2,Process1_3,Process1_4,Process1_5]が存在することになります。
    あなたにはJSON形式のプロンプトを書いてもらいます。以下にJSON形式を用意しました。""の内部に適切な文章を埋めてください。ただし埋める文章は最大20文字までとします。
    ["tille":" "]の""内部には{}の文字列を要約して埋めてください。ただし埋める文章は最大10文字までとします。
    
    ＜注意＞
    ChatGPTあなたの返信は以下のJSON形式のみとします。必ず守るようにしてください。
    
    
    {
      "title":" ",
      "Process":{
        "Process1" : " ",
        "Process2" : " ",
        "Process3" : " ",
        "Process4" : " ",
        "Process5" : " ",
        "Process1_1" : " ",
        "Process1_2" : " ",
        "Process1_3" : " ",
        "Process1_4" : " ",
        "Process1_5" : " ",
        "Process2_1" : " ",
        "Process2_2" : " ",
        "Process2_3" : " ",
        "Process2_4" : " ",
        "Process2_5" : " ",
        "Process3_1" : " ",
        "Process3_2" : " ",
        "Process3_3" : " ",
        "Process3_4" : " ",
        "Process3_5" : " ",
        "Process4_1" : " ",
        "Process4_2" : " ",
        "Process4_3" : " ",
        "Process4_4" : " ",
        "Process4_5" : " ",
        "Process5_1" : " ",
        "Process5_2" : " ",
        "Process5_3" : " ",
        "Process5_4" : " ",
        "Process5_5" : " "
        }
      }
      CONFIG
    question = params[:question]
    Rails.logger.debug(question)
    
    
    response = generate_story(config, question)

    process = response["Process"]
    array = [process["Process1"], process["Process2"], process["Process3"], process["Process4"], process["Process5"], 
    process["Process1-1"], process["Process1-2"], process["Process1-3"], process["Process1-4"], process["Process1-5"], 
    process["Process2-1"], process["Process2-2"], process["Process2-3"], process["Process2-4"], process["Process2-5"], 
    process["Process3-1"], process["Process3-2"], process["Process3-3"], process["Process3-4"], process["Process3-5"], 
    process["Process4-1"], process["Process4-2"], process["Process4-3"], process["Process4-4"], process["Process4-5"], 
    process["Process5-1"], process["Process5-2"], process["Process5-3"], process["Process5-4"], process["Process5-5"]]
    
    mission = Mission.new
    mission.title = response["title"]
    mission.progress = 1
    mission.save
    
    array.each do |res|
      sub = SubMission.new
      sub.mission = mission
      sub.content = res
      sub.save
    end

    render :json => {
      "title": response["title"],
      "response": array,
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
      sub.each do |submi|
        process_key = "Process#{json_data[goal_key]["Progress"].size + 1}"
        json_data[goal_key]["Progress"][process_key] = submi.content
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
      Rails.logger.debug(response.dig('choices', 0, 'message', 'content'))
      json = JSON.parse(response.dig('choices', 0, 'message', 'content'))
    return json
  end
end
