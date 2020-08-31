let currentlyMouseDown = false;
let currentColor = "rgb(0,0,0)";
let opacityLevelNumber = 10;

function newGrid(size){
    if (isNaN(size)) {
        return;
    }
    //remove old grid
    let container = document.querySelector("#container");
    container.parentNode.removeChild(container);
    container = document.createElement("div");

    document.querySelector("#game").appendChild(container);
    container.setAttribute("id", "container");
    container.onmousedown = function () {currentlyMouseDown=true;};
    container.onmouseup = function () {currentlyMouseDown=false;}; 

    for (let i = 0; i < size; i++) {
        let row = document.createElement("div");
        for (let j = 0; j < size; j++) {
            let newChild = document.createElement("div");
            newChild.onmouseover = hoverChangeBackgroundColor;
            newChild.onmousedown = function () {changeBackgroundColor(this)};
            newChild.style.setProperty("--opacity-value", "0");
            newChild.ondragstart = function () {return false};
            row.appendChild(newChild);
        }
        container.appendChild(row);
        
    }
    newThemeColor();
}

function promptGridSize(){
    entry = parseInt(prompt("Please enter new grid size: ", "16"));

    return entry;
}

function newGridOnClick(){
    let size = promptGridSize();
    newGrid(size);
}

function hoverChangeBackgroundColor(){
    if (currentlyMouseDown){
        changeBackgroundColor(this)
    }
}

function changeBackgroundColor(grid){
    if (grid.style.backgroundColor != currentColor) {
        grid.style.backgroundColor = currentColor;
        grid.style.setProperty("--opacity-value","0");
    }

    let newValue = parseInt(grid.style.getPropertyValue("--opacity-value"))+100/opacityLevelNumber;
    grid.style.filter = `opacity(${newValue}%)`
    grid.style.setProperty("--opacity-value", `${newValue}%`);
}

function randomColValue(){
    return Math.round(Math.random()*255/3);
}

function randomColor(){
    return `rgb(${randomColValue()}, ${randomColValue()}, ${randomColValue()})`;
}

function chooseOpacitLevelsOnClick(){
    let number = prompt("Enter new amount of opacity levels:", "10");
    if (number != null){
        opacityLevelNumber = number;
    }
}

function newThemeColor(){
    let color = randomColor();
    document.documentElement.style.setProperty("--bg-color", color);
    currentColor = color;
    console.log(`background color = ${color}`);
}

newGrid(16);





