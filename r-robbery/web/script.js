window.addEventListener('message', function(event) {
    if (event.data.action === 'showNotification') {
        document.getElementById('notification-text').textContent = event.data.text;
        document.getElementById('notification').classList.remove('hidden');

        setTimeout(() => {
            document.getElementById('notification').classList.add('hidden');
        }, event.data.duration);
    }
});
