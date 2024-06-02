import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
    const chatRoomElement = document.getElementById('chat_room_id');
    if (chatRoomElement) {
        const chatRoomId = chatRoomElement.getAttribute('data-chat-room-id');

        consumer.subscriptions.create({ channel: "ChatRoomChannel", chat_room_id: chatRoomId }, {
            connected() {
                console.log(`Connected to ChatRoomChannel ${chatRoomId}`);
            },

            disconnected() {
                // Called when the subscription has been terminated by the server
            },

            received(data) {
                const messages = document.getElementById('messages');
                messages.insertAdjacentHTML('beforeend', data.message);
            }
        });
    }
});
