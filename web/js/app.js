const pMenu = document.querySelector(".container")
const playerCash = document.querySelector("#cash")
const playerName = document.querySelector("#name")
const playerJob = document.querySelector("#job")
const confermBox = document.querySelector("#conferm-container")

window.addEventListener('message', (event) => {
    if (event.data.action === 'open') {
        playerCash.innerHTML = event.data.money
        playerName.innerHTML = event.data.name
        playerJob.innerHTML = event.data.job
        
        pMenu.style.display = "block"
    } else if (event.data.action === 'close') {
        pMenu.style.display = "none"
    }
});


function post(path) {
    fetch(path, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json());
}

function openMap() {
    post(`https://ars_pausemenu/openMap`)
}

function openSettings() {
    post(`https://ars_pausemenu/openSettings`)
}

function disconnect() {
    post(`https://ars_pausemenu/disconnect`)
}

function cancelDisconnect() {
    post(`https://ars_pausemenu/close`)
    confermBox.style.display = "none"
}
function openConfermBox() {
    pMenu.style.display = "none"
    confermBox.style.display = "flex"
}

document.onkeydown = function(evt) {
    evt = evt || window.event;
    var isEscape = false;
    if ("key" in evt) {
        isEscape = (evt.key === "Escape" || evt.key === "Esc");
    } else {
        isEscape = (evt.keyCode === 27);
    }
    if (isEscape) {
        post(`https://ars_pausemenu/close`)
        confermBox.style.display = "none"
    }
};