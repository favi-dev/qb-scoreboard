let dataSetup = false;
let styleSetup = false;
var style = 0;
window.addEventListener("message", (event) => {
    switch (event.data.action) {
        case "open":
            Open(event.data);
            break;
        case "close":
            Close();
            break;
        case "setup":
            Setup(event.data);
            break;
        case "appendStyle":
            document.head.innerHTML += `<style>${event.data.style}</style>`;
            styleSetup = true;
            break;
    }
});

const Open = (data) => {
    // if (!dataSetup) { return console.log('scoreboard has not been through setup try again'); }
    $(".infoboard-main").fadeIn(150);
    $("#total-players").html(data.players + "<small>/</small>" + data.maxPlayers + "</p>");
    $("#total-min").html(`<p>${data.time}</p>`)
    $("#total-cops").html("<p>" + (data.currentCops > 0 ? "<span class='fon'>ON</span>" : '<span class="foff">NONE</span>') + "</p>");
    $("#total-ambulance").html("<p>" + (data.currentambulance > 0 ? "<span class='fon'>ON</span>" : '<span class="foff">NONE</span>') + "</p>");
    $.each(data.requiredCops, (i, category) => {
        var beam = $(".scoreboard-info").find('[data-type="' + i + '"]');
        var status = $(beam).find(".info-beam-status");
        if (category.busy)
            $(status).html('<span class="fbusy">BUSY</span>');
        else if (data.currentCops >= category.minimumPolice)
            $(status).html('<span class="fon">ON</span>');
        else
            $(status).html('<span class="foff">OFF</span>');
    });
};

const Close = () => {
    $(".infoboard-main").fadeOut(150);
};


const Setup = (data) => {
    if (style === 2) {
            
        $('.container').css({
            'display': 'flex',
            'justify-content': 'center',
        })
        $('.infoboard-main').css({
            'position': 'relative',
            'top': '0vh',
            'left': '0vh',
            'right': '0vh',
            'bottom': '0vh',
            'width': '50vh',
            'height': '7vh',
        })
    }
    let scoreboardHtml = "";
    $.each(data.items, (index, value) => {
        scoreboardHtml += `
    <div class="scoreboard-info-beam" data-type=${index}>
      <div class="info-beam-title">
          <p>${value}</p>
      </div>
      <div class="info-beam-status"></div>
    </div>
  `;
    });
    scoreboardHtml += `<div class="scoreboard-info-beam">    <div class="info-beam-title-players">    <div class="text"><i class="fa-solid fa-handcuffs"></i></div> <div class="text">Online Cops</div>      </div>  <div class="info-beam-status" id="total-cops" style="color: #0c8ee5">12</div>  </div>      <div class="scoreboard-info-beam">    <div class="info-beam-title-players">     <div class="text"><i class="fa-solid fa-truck-medical"></i></div>  <div class="text">Online Ems</div>         </div>    <div class="info-beam-status" id="total-ambulance" style="color: #0c8ee5">15</div>    </div>    <div class="scoreboard-info-beam somthingrandom">    <div style="color:#ededed;" class="info-beam-title-players"> <div class="text"><i class="fa-solid fa-people-group"></i></div> <div class="text">Players</div>    </div>  <div class="info-beam-status" id="total-players" style="color: #0c8ee5"><p>15/120</p></div>  </div>  <div class="scoreboard-info-beam somthingrandom">  <div style="color:#ededed;" class="info-beam-title-players">  <div class="text"><i class="fa-solid fa-stopwatch"></i></div> <div class="text">Play Time</div>  </div><div class="info-beam-status" id="total-min" style="color: #0c8ee5"><p>0h/12m</p></div>`;
    $(".scoreboard-info").html(scoreboardHtml);
    dataSetup = true;
};
