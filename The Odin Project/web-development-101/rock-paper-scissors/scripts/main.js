
function playerChoiceButtonOnClick(){
    playerChoice = this.id;
    animatePlayerButtonToCenter(this)
    let computerChoice = computerChoiceAndAnimation();
    decideWinner(playerChoice, computerChoice);
    document.querySelector("#next-round").classList.remove("fade");
    document.querySelector("#next-round").removeAttribute("disabled");
}

function animatePlayerButtonToCenter(button){
    let buttons = button.parentElement.children;
    for (let i = 0; i < buttons.length; i++) {
        if (buttons[i] != button) { buttons[i].classList.toggle("fade")};
        buttons[i].setAttribute("disabled", true);
    }
    buttons[0].classList.toggle("movedown");
    buttons[2].classList.toggle("moveup");
}

function computerChoiceAndAnimation(){
    let buttons = document.querySelector("#player-selection").children;
    let num = Math.floor(Math.random() * 3);

    let actual = document.querySelector("#computer-selection #actual");
    actual.src = buttons[num].src;
    actual.classList.remove("fade");
    document.querySelector("#computer-selection #question-mark").classList.toggle("fade");
    return buttons[num].id;

}

function decideWinner(playerChoice, computerChoice){

    if (playerChoice == computerChoice) return;

    else if (playerChoice == "rock" && computerChoice == "scissors" ||
        playerChoice == "paper" && computerChoice == "rock" ||
        playerChoice == "scissors" && computerChoice == "paper") {
        
        let playerText = document.querySelector("#points #player");
        let points = parseInt(playerText.textContent.split(":")[1]);
        playerText.textContent = `Player: ${points+1}`;

    }
    else{
        let computerText = document.querySelector("#points #computer");
        let points = parseInt(computerText.textContent.split(":")[1]);
        computerText.textContent = `Computer: ${points+1}`;
    }
}

function nextRoundOnClick(){
    let roundTracker = document.querySelector("#round-tracker");
    let number = parseInt(roundTracker.textContent.split(" ")[1]);
    this.classList.add("fade");
    this.setAttribute("disabled", true);
    if (number == 5) {
        this.style.visibility = "hidden";
        endGame()
        return;
    }
    roundTracker.textContent = `Round ${number+1} of 5`;
    resetToInitialPosition();
}

function resetToInitialPosition(){
    let buttons = document.querySelector("#play-area #player-selection").children;
    for (let i = 0; i < buttons.length; i++){
        buttons[i].removeAttribute("disabled");
        buttons[i].classList.remove("fade");
    }
    buttons[0].classList.remove("movedown");
    buttons[2].classList.remove("moveup");

    let qustnMark = document.querySelector("#play-area #computer-selection #question-mark");
    qustnMark.previousElementSibling.classList.add("fade")
    qustnMark.classList.remove("fade");

}

function endGame(){
    let playerText = document.querySelector("#points #player");
    let playerPoints = parseInt(playerText.textContent.split(":")[1]);
    let computerText = document.querySelector("#points #computer");
    let computerPoints = parseInt(computerText.textContent.split(":")[1]);

    let roundOver = document.querySelector("#round-over");
    roundOver.removeAttribute("hidden");

    let winLoss = roundOver.querySelector("#win-loss")

    if (playerPoints == computerPoints) {
        winLoss.textContent = "Tie!"
    }
    else if (playerPoints > computerPoints) {
        winLoss.textContent = "You won!"
    }
    else{
        winLoss.textContent = "You lost!"
    }
}

let buttons = document.querySelector("#player-selection").children;
for (let i=0; i < buttons.length; i++) {
    buttons[i].onclick = playerChoiceButtonOnClick;
}

document.querySelector("#next-round").onclick = nextRoundOnClick;