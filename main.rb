require 'telegram/bot'
require './secure.rb'
require './vika_phrases.rb'
require './nastya_phrases.rb'
require './general_phrases.rb'

def send_message(bot, chat_id, text)
  bot.api.send_message(
    chat_id:chat_id,
    text: text
  )
end

def answer_to_lovely_girl(bot, chat_id, text, owner_chat_id, owner_text)
  send_message(bot, chat_id, text)
  send_message(bot, owner_chat_id, owner_text)
end

def bot_activity(bot, message)
  case message.from.username
  when VIKA_USERNAME
    text = (PHRASES_FOR_VIKA + GENERAL_PHRASES).sample
    answer_to_lovely_girl(bot, message.chat.id, text, ARSENIJ_ID, "Торя ждёт, Торя плачет\nЕё любимый говорит: #{text}")
  when NASTYA_USERNAME
    text = (PHRASES_FOR_NASTYA + GENERAL_PHRASES).sample
    answer_to_lovely_girl(bot, message.chat.id, text, DENIS_ID, "Настюшка-Сплюшка скучает 💟\nЕе порадовало: #{text}")
  when DENIS_USERNAME
    send_message(bot, message.chat.id, 'Обожаю вас, мой хозяин')
    send_message(bot, message.chat.id, "Вашей любимой доступно #{(PHRASES_FOR_NASTYA + GENERAL_PHRASES).count} приятных фраз")
  when ARSENIJ_USERNAME
    send_message(bot, message.chat.id, 'Вассап, Нигга')
    send_message(bot, message.chat.id, "Вашей любимой доступно #{(PHRASES_FOR_VIKA + GENERAL_PHRASES).count} приятных фраз")
  else
    send_message(bot, message.chat.id, 'Тебя никто не любит, пошел нахуй отсюда. Умри.')
  end
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    bot_activity(bot, message)
  end
end
