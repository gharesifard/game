<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <title>Alice's Star Garden</title>
  <style>
    :root {
      color-scheme: dark;
      --bg: #101318;
      --panel: #1b2129;
      --ink: #f6f1e8;
      --muted: #aeb8c4;
      --gold: #ffd166;
      --mint: #75e0a7;
      --rose: #ff7b9c;
      --sky: #78c8ff;
      --danger: #ff5f57;
    }

    * {
      box-sizing: border-box;
      -webkit-tap-highlight-color: transparent;
    }

    html {
      width: 100%;
      height: 100%;
      overflow: hidden;
      overscroll-behavior: none;
    }

    body {
      margin: 0;
      width: 100%;
      height: 100%;
      min-height: 100vh;
      min-height: 100dvh;
      background:
        radial-gradient(circle at 18% 12%, rgba(255, 209, 102, 0.24), transparent 24rem),
        radial-gradient(circle at 82% 22%, rgba(255, 123, 156, 0.22), transparent 24rem),
        radial-gradient(circle at 50% 0%, rgba(120, 200, 255, 0.28), transparent 30rem),
        linear-gradient(180deg, #233b6d 0%, #3c6f94 48%, #507946 100%);
      color: var(--ink);
      font-family: Avenir, "Avenir Next", Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      overflow: hidden;
      overscroll-behavior: none;
      position: fixed;
      inset: 0;
      user-select: none;
      -webkit-user-select: none;
      -webkit-touch-callout: none;
    }

    .game {
      display: grid;
      grid-template-rows: auto 1fr auto;
      width: 100vw;
      height: 100vh;
      height: 100dvh;
    }

    header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
      padding: calc(0.85rem + env(safe-area-inset-top)) calc(clamp(1rem, 3vw, 2rem) + env(safe-area-inset-right)) 0.85rem calc(clamp(1rem, 3vw, 2rem) + env(safe-area-inset-left));
      background: rgba(16, 19, 24, 0.78);
      border-bottom: 1px solid rgba(246, 241, 232, 0.11);
      backdrop-filter: blur(12px);
    }

    h1 {
      margin: 0;
      font-size: clamp(1.15rem, 2.5vw, 1.8rem);
      font-weight: 800;
      letter-spacing: 0;
    }

    .stats {
      display: flex;
      align-items: center;
      gap: 0.55rem;
      flex-wrap: wrap;
      justify-content: flex-end;
    }

    .stat {
      min-width: 5.5rem;
      padding: 0.48rem 0.65rem;
      border: 1px solid rgba(246, 241, 232, 0.15);
      border-radius: 8px;
      background: rgba(27, 33, 41, 0.88);
      text-align: center;
      touch-action: manipulation;
    }

    .stat strong {
      display: block;
      color: var(--gold);
      font-size: 1rem;
      line-height: 1.1;
    }

    .stat span {
      color: var(--muted);
      font-size: 0.72rem;
      text-transform: uppercase;
    }

    .stat.damaged {
      animation: stat-damage 620ms ease;
    }

    .sound-toggle {
      min-width: 3.1rem;
      min-height: 3.1rem;
      padding: 0 0.75rem;
      border: 1px solid rgba(246, 241, 232, 0.18);
      border-radius: 8px;
      background: rgba(27, 33, 41, 0.88);
      color: var(--ink);
      box-shadow: none;
      font-size: 1.2rem;
    }

    .sound-toggle.on {
      background: rgba(117, 224, 167, 0.86);
      color: #102018;
    }

    .reward-shelf {
      position: absolute;
      top: 1rem;
      left: 1rem;
      z-index: 2;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      width: min(17rem, calc(100% - 2rem));
      pointer-events: none;
    }

    .reward-title {
      color: rgba(246, 241, 232, 0.78);
      font-size: 0.75rem;
      font-weight: 800;
      text-transform: uppercase;
    }

    .badges {
      display: flex;
      flex-wrap: wrap;
      gap: 0.4rem;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 2.35rem;
      height: 2.35rem;
      padding: 0 0.5rem;
      border: 1px solid rgba(255, 209, 102, 0.58);
      border-radius: 8px;
      background: rgba(27, 33, 41, 0.86);
      color: var(--gold);
      font-size: 1.22rem;
      font-weight: 900;
      box-shadow: 0 0.55rem 1.4rem rgba(0, 0, 0, 0.22), inset 0 0 1.2rem rgba(255, 209, 102, 0.1);
      transform-origin: center;
      animation: badge-pop 380ms ease-out;
    }

    .reward-toast {
      position: absolute;
      top: 1rem;
      right: 1rem;
      z-index: 3;
      max-width: min(19rem, calc(100% - 2rem));
      padding: 0.72rem 0.9rem;
      border: 1px solid rgba(255, 209, 102, 0.48);
      border-radius: 8px;
      background: rgba(27, 33, 41, 0.95);
      color: var(--ink);
      font-weight: 850;
      box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.28);
      opacity: 0;
      transform: translateY(-0.6rem) scale(0.96);
      pointer-events: none;
    }

    .reward-toast.show {
      animation: reward-toast 1500ms ease both;
    }

    .penalty-burst {
      position: absolute;
      left: 50%;
      top: 44%;
      z-index: 6;
      display: grid;
      place-items: center;
      width: min(22rem, calc(100% - 2rem));
      min-height: 5.5rem;
      padding: 0.85rem 1rem;
      border: 3px solid rgba(120, 200, 255, 0.9);
      border-radius: 8px;
      background: rgba(31, 47, 84, 0.94);
      color: #f4fbff;
      font-size: clamp(1.45rem, 7vw, 3.2rem);
      font-weight: 950;
      text-align: center;
      text-shadow: 0 0.15rem 0 rgba(0, 0, 0, 0.35);
      box-shadow: 0 1rem 2.4rem rgba(0, 0, 0, 0.36), 0 0 2rem rgba(120, 200, 255, 0.38);
      opacity: 0;
      transform: translate(-50%, -50%) scale(0.76);
      pointer-events: none;
    }

    .penalty-burst.show {
      animation: penalty-burst 920ms ease both;
    }

    @keyframes badge-pop {
      0% {
        transform: scale(0.35) rotate(-10deg);
        opacity: 0;
      }
      70% {
        transform: scale(1.14) rotate(3deg);
        opacity: 1;
      }
      100% {
        transform: scale(1) rotate(0);
      }
    }

    @keyframes reward-toast {
      0% {
        opacity: 0;
        transform: translateY(-0.6rem) scale(0.96);
      }
      14%, 78% {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
      100% {
        opacity: 0;
        transform: translateY(-0.35rem) scale(0.98);
      }
    }

    @keyframes penalty-burst {
      0% {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.58) rotate(-4deg);
      }
      18%, 70% {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1.04) rotate(1deg);
      }
      100% {
        opacity: 0;
        transform: translate(-50%, -50%) scale(1.16) rotate(0);
      }
    }

    @keyframes stat-damage {
      0%, 100% {
        transform: scale(1);
        border-color: rgba(246, 241, 232, 0.15);
      }
      25%, 70% {
        transform: scale(1.08);
        border-color: rgba(120, 200, 255, 0.95);
        background: rgba(31, 47, 84, 0.95);
      }
    }

    main {
      position: relative;
      overflow: hidden;
    }

    canvas {
      display: block;
      width: 100%;
      height: 100%;
      cursor: crosshair;
      touch-action: none;
    }

    .overlay {
      position: absolute;
      inset: 0;
      display: grid;
      place-items: center;
      padding: 1.25rem;
      background: rgba(16, 19, 24, 0.38);
      z-index: 5;
    }

    .dialog {
      width: min(31rem, 100%);
      padding: clamp(1rem, 4vw, 1.6rem);
      border: 1px solid rgba(246, 241, 232, 0.15);
      border-radius: 8px;
      background: rgba(27, 33, 41, 0.94);
      box-shadow: 0 1.5rem 4rem rgba(0, 0, 0, 0.35);
      text-align: center;
    }

    .dialog h2 {
      margin: 0 0 0.45rem;
      font-size: clamp(1.6rem, 8vw, 3rem);
      line-height: 1;
      letter-spacing: 0;
    }

    .dialog p {
      margin: 0 auto 1rem;
      max-width: 25rem;
      color: var(--muted);
      line-height: 1.5;
    }

    .animal-chooser {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 0.55rem;
      margin: 1rem 0;
    }

    .animal-option {
      min-height: 4.4rem;
      padding: 0.45rem;
      border: 2px solid rgba(246, 241, 232, 0.16);
      border-radius: 8px;
      background: rgba(246, 241, 232, 0.08);
      color: var(--ink);
      box-shadow: none;
    }

    .animal-option strong,
    .animal-option span {
      display: block;
    }

    .animal-option strong {
      font-size: 1.7rem;
      line-height: 1.1;
    }

    .animal-option span {
      color: var(--muted);
      font-size: 0.76rem;
      font-weight: 800;
    }

    .animal-option.selected {
      border-color: rgba(255, 209, 102, 0.92);
      background: rgba(255, 209, 102, 0.18);
    }

    .animal-option.locked {
      opacity: 0.5;
      filter: grayscale(0.45);
    }

    button {
      min-height: 3.1rem;
      padding: 0 1.25rem;
      border: 0;
      border-radius: 8px;
      background: var(--mint);
      color: #102018;
      font: inherit;
      font-weight: 800;
      cursor: pointer;
      touch-action: manipulation;
      box-shadow: 0 0.45rem 0 #3f9f70;
      transition: transform 120ms ease, box-shadow 120ms ease, filter 120ms ease;
    }

    button:hover {
      filter: brightness(1.05);
    }

    button:active {
      transform: translateY(0.25rem);
      box-shadow: 0 0.2rem 0 #3f9f70;
    }

    footer {
      display: flex;
      justify-content: center;
      gap: clamp(0.65rem, 4vw, 2rem);
      padding: 0.75rem 1rem;
      color: var(--muted);
      background: rgba(16, 19, 24, 0.78);
      border-top: 1px solid rgba(246, 241, 232, 0.11);
      font-size: clamp(0.78rem, 2vw, 0.95rem);
      padding-bottom: calc(0.75rem + env(safe-area-inset-bottom));
    }

    .touch-controls {
      position: absolute;
      left: max(1rem, env(safe-area-inset-left));
      right: max(1rem, env(safe-area-inset-right));
      bottom: calc(1rem + env(safe-area-inset-bottom));
      z-index: 4;
      display: grid;
      grid-template-columns: 4.4rem 4.4rem 4.4rem;
      grid-template-areas:
        ". up pause"
        "left down right";
      justify-content: center;
      align-items: center;
      gap: 0.85rem;
      pointer-events: none;
    }

    .touch-button {
      display: grid;
      place-items: center;
      width: 4.4rem;
      height: 4.4rem;
      border: 1px solid rgba(246, 241, 232, 0.18);
      border-radius: 8px;
      background: rgba(27, 33, 41, 0.8);
      color: var(--ink);
      font-size: 2.2rem;
      font-weight: 900;
      box-shadow: 0 0.45rem 0 rgba(0, 0, 0, 0.28);
      pointer-events: auto;
      touch-action: none;
    }

    .touch-button.pause {
      grid-area: pause;
      width: 3.7rem;
      height: 3.7rem;
      background: rgba(117, 224, 167, 0.86);
      color: #102018;
      font-size: 1.55rem;
    }

    #touchLeft {
      grid-area: left;
    }

    #touchRight {
      grid-area: right;
    }

    #touchUp {
      grid-area: up;
    }

    #touchDown {
      grid-area: down;
    }

    .touch-button:active,
    .touch-button.pressed {
      transform: translateY(0.22rem);
      box-shadow: 0 0.22rem 0 rgba(0, 0, 0, 0.32);
      filter: brightness(1.1);
    }

    kbd {
      display: inline-grid;
      place-items: center;
      min-width: 1.65rem;
      height: 1.55rem;
      padding: 0 0.35rem;
      border: 1px solid rgba(246, 241, 232, 0.2);
      border-bottom-color: rgba(246, 241, 232, 0.38);
      border-radius: 6px;
      background: rgba(246, 241, 232, 0.08);
      color: var(--ink);
      font-family: inherit;
      font-size: 0.85em;
    }

    .hidden {
      display: none;
    }

    @media (max-width: 640px) {
      header {
        align-items: flex-start;
        flex-direction: column;
      }

      .stats {
        width: 100%;
        justify-content: space-between;
      }

      .stat {
        flex: 1;
        min-width: 0;
      }

      footer {
        flex-wrap: wrap;
      }

      .animal-chooser {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .reward-shelf,
      .reward-toast {
        top: 0.65rem;
        left: 0.65rem;
        right: 0.65rem;
        width: auto;
        max-width: none;
      }

      .reward-toast {
        top: auto;
        bottom: 0.65rem;
      }
    }

    canvas {
      cursor: default;
    }

    footer span:first-child,
    footer span:nth-child(2) {
      display: none;
    }

    @media (min-width: 641px) and (max-width: 1180px) {
      header {
        padding-top: calc(0.75rem + env(safe-area-inset-top));
        padding-bottom: 0.7rem;
      }

      .stat {
        min-width: 6.5rem;
        padding: 0.58rem 0.8rem;
      }

      .stat strong {
        font-size: 1.15rem;
      }

      .reward-shelf {
        top: 0.8rem;
      }
    }

    @media (orientation: landscape) and (max-height: 760px) {
      footer {
        display: none;
      }

      .touch-controls {
        bottom: calc(0.65rem + env(safe-area-inset-bottom));
      }
    }
  </style>
</head>
<body>
  <div class="game">
    <header>
      <h1>Alice's Star Garden</h1>
      <div class="stats" aria-label="Game stats">
        <div class="stat"><strong id="score">0</strong><span>Stars</span></div>
        <div class="stat"><strong id="lives">3</strong><span>Hearts</span></div>
        <div class="stat"><strong id="level">1</strong><span>Round</span></div>
        <button class="sound-toggle" id="soundToggle" type="button" aria-label="Turn sound on">♪</button>
      </div>
    </header>

    <main>
      <div class="reward-shelf" aria-live="polite">
        <div class="reward-title">Rewards</div>
        <div class="badges" id="badges"></div>
      </div>
      <div class="reward-toast" id="rewardToast" aria-live="polite"></div>
      <div class="penalty-burst" id="penaltyBurst" aria-live="assertive"></div>
      <canvas id="canvas" aria-label="Alice's Star Garden game area"></canvas>
      <div class="touch-controls" aria-label="Touch controls">
        <button class="touch-button" id="touchUp" type="button" aria-label="Move up">⌃</button>
        <button class="touch-button" id="touchLeft" type="button" aria-label="Move left">‹</button>
        <button class="touch-button" id="touchDown" type="button" aria-label="Move down">⌄</button>
        <button class="touch-button pause" id="touchPause" type="button" aria-label="Pause">Ⅱ</button>
        <button class="touch-button" id="touchRight" type="button" aria-label="Move right">›</button>
      </div>
      <div class="overlay" id="overlay">
        <section class="dialog">
          <h2 id="title">Ready?</h2>
          <p id="message">Choose an animal, fill the rainbow, and discover the mystery friends one by one.</p>
          <div class="animal-chooser" id="animalChooser" aria-label="Choose animal"></div>
          <button id="start">Start Game</button>
        </section>
      </div>
    </main>

    <footer>
      <span><kbd>←</kbd> <kbd>→</kbd> move</span>
      <span><kbd>Space</kbd> pause</span>
      <span>More stars make the garden happier</span>
    </footer>
  </div>

  <script>
    const canvas = document.querySelector("#canvas");
    const ctx = canvas.getContext("2d");
    const scoreEl = document.querySelector("#score");
    const livesEl = document.querySelector("#lives");
    const levelEl = document.querySelector("#level");
    const soundToggle = document.querySelector("#soundToggle");
    const overlay = document.querySelector("#overlay");
    const titleEl = document.querySelector("#title");
    const messageEl = document.querySelector("#message");
    const startButton = document.querySelector("#start");
    const animalChooser = document.querySelector("#animalChooser");
    const badgesEl = document.querySelector("#badges");
    const rewardToast = document.querySelector("#rewardToast");
    const penaltyBurst = document.querySelector("#penaltyBurst");
    const touchLeft = document.querySelector("#touchLeft");
    const touchRight = document.querySelector("#touchRight");
    const touchUp = document.querySelector("#touchUp");
    const touchDown = document.querySelector("#touchDown");
    const touchPause = document.querySelector("#touchPause");

    const keys = new Set();
    const rewardMilestones = [
      { score: 3, icon: "A+", name: "First Glow" },
      { score: 8, icon: "WOW", name: "Bright Catcher" },
      { score: 15, icon: "YES", name: "Garden Helper" },
      { score: 25, icon: "ACE", name: "Star Champion" },
      { score: 40, icon: "PRO", name: "Sky Hero" }
    ];
    const flowerPalette = [
      "#ff7b9c",
      "#78c8ff",
      "#ffd166",
      "#b390ff",
      "#ff9f43",
      "#75e0a7"
    ];
    const animals = [
      { id: "bunny", name: "Bunny", icon: "BUN", unlock: 0, body: "#fff6f4", accent: "#ffb3c2" },
      { id: "kitty", name: "Kitty", icon: "CAT", unlock: 0, body: "#ffe0a8", accent: "#ff9f43" },
      { id: "pup", name: "Puppy", icon: "PUP", unlock: 1, body: "#f4d0ad", accent: "#8b5e3c" },
      { id: "panda", name: "Panda", icon: "PAN", unlock: 2, body: "#f7f4ef", accent: "#1b2129" },
      { id: "fox", name: "Fox", icon: "FOX", unlock: 3, body: "#ff9f43", accent: "#fff6f4" },
      { id: "unicorn", name: "Unicorn", icon: "UNI", unlock: 4, body: "#fff6f4", accent: "#b390ff" }
    ];
    const mysteryAnimalCount = 4;

    const state = {
      running: false,
      paused: false,
      score: 0,
      lives: 3,
      level: 1,
      lastTime: 0,
      spawnTimer: 0,
      obstacleTimer: 0,
      shootingTimer: 0,
      sparkleTimer: 0,
      penaltyTimer: 0,
      touchX: 0,
      touchY: 0,
      objects: [],
      obstacles: [],
      sparkles: [],
      floaters: [],
      earnedRewards: [],
      rainbowComplete: false,
      mysteryFound: 0,
      round: 1,
      awaitingNextRound: false,
      gameWon: false,
      selectedAnimal: "bunny",
      partyTimer: 0,
      celebrationUntil: 0,
      celebrationFinal: false,
      soundOn: false,
      audioContext: null,
      stars: []
    };

    const player = {
      x: 0,
      y: 0,
      width: 68,
      height: 62,
      speed: 430,
      targetX: null,
      targetY: null
    };

    function resize() {
      const rect = canvas.getBoundingClientRect();
      const scale = window.devicePixelRatio || 1;
      canvas.width = Math.max(1, Math.floor(rect.width * scale));
      canvas.height = Math.max(1, Math.floor(rect.height * scale));
      ctx.setTransform(scale, 0, 0, scale, 0, 0);
      player.y = Math.min(Math.max(player.y || rect.height - bottomPlaySpace(), topPlayLimit()), bottomPlayLimit());
      player.x = Math.min(Math.max(player.x, player.width / 2), rect.width - player.width / 2);
      seedBackgroundStars();
    }

    function bottomPlaySpace() {
      return 126;
    }

    function topPlayLimit() {
      return Math.max(64, height() * 0.18);
    }

    function bottomPlayLimit() {
      return height() - bottomPlaySpace();
    }

    function width() {
      return canvas.getBoundingClientRect().width;
    }

    function height() {
      return canvas.getBoundingClientRect().height;
    }

    function seedBackgroundStars() {
      const count = Math.round((width() * height()) / 17000);
      state.stars = Array.from({ length: count }, () => ({
        x: Math.random() * width(),
        y: Math.random() * height(),
        r: Math.random() * 1.8 + 0.45,
        pulse: Math.random() * Math.PI * 2
      }));
    }

    function startGame() {
      state.mysteryFound = 0;
      state.round = 1;
      state.awaitingNextRound = false;
      state.gameWon = false;
      if (!isAnimalUnlocked(currentAnimal())) state.selectedAnimal = "bunny";
      beginRound(true);
    }

    function beginRound(resetHearts) {
      state.running = true;
      state.paused = false;
      state.score = 0;
      if (resetHearts) state.lives = 3;
      state.level = state.round;
      state.lastTime = performance.now();
      state.spawnTimer = 0;
      state.obstacleTimer = 1.6;
      state.shootingTimer = 4.5;
      state.sparkleTimer = 0;
      state.penaltyTimer = 0;
      state.touchX = 0;
      state.touchY = 0;
      state.objects = [];
      state.obstacles = [];
      state.sparkles = [];
      state.floaters = [];
      state.earnedRewards = [];
      state.rainbowComplete = false;
      state.awaitingNextRound = false;
      state.partyTimer = 0;
      state.celebrationUntil = 0;
      state.celebrationFinal = false;
      player.x = width() / 2;
      player.y = bottomPlayLimit();
      player.targetX = null;
      player.targetY = null;
      renderRewards();
      announceReward("Catch stars to earn rewards");
      overlay.classList.add("hidden");
      updateStats();
      requestAnimationFrame(loop);
    }

    function updateStats() {
      scoreEl.textContent = state.score;
      livesEl.textContent = state.lives;
      levelEl.textContent = state.level;
    }

    function updateSoundToggle() {
      soundToggle.classList.toggle("on", state.soundOn);
      soundToggle.textContent = state.soundOn ? "♪" : "♫";
      soundToggle.setAttribute("aria-label", state.soundOn ? "Turn sound off" : "Turn sound on");
    }

    function ensureAudio() {
      if (!state.audioContext) {
        const AudioContextClass = window.AudioContext || window.webkitAudioContext;
        if (!AudioContextClass) return null;
        state.audioContext = new AudioContextClass();
      }
      if (state.audioContext.state === "suspended") state.audioContext.resume();
      return state.audioContext;
    }

    function playTone(frequency, duration = 0.16, type = "sine", volume = 0.055, delay = 0) {
      if (!state.soundOn) return;
      const audio = ensureAudio();
      if (!audio) return;
      const start = audio.currentTime + delay;
      const oscillator = audio.createOscillator();
      const gain = audio.createGain();
      oscillator.type = type;
      oscillator.frequency.setValueAtTime(frequency, start);
      gain.gain.setValueAtTime(0.0001, start);
      gain.gain.exponentialRampToValueAtTime(volume, start + 0.018);
      gain.gain.exponentialRampToValueAtTime(0.0001, start + duration);
      oscillator.connect(gain);
      gain.connect(audio.destination);
      oscillator.start(start);
      oscillator.stop(start + duration + 0.025);
    }

    function playSound(name) {
      if (name === "star") {
        playTone(660, 0.12, "sine", 0.045);
        playTone(880, 0.14, "sine", 0.036, 0.045);
      } else if (name === "moon") {
        playTone(523, 0.18, "triangle", 0.05);
        playTone(784, 0.22, "sine", 0.042, 0.075);
      } else if (name === "heart") {
        playTone(392, 0.16, "sine", 0.045);
        playTone(523, 0.16, "sine", 0.04, 0.08);
      } else if (name === "bump") {
        playTone(196, 0.12, "triangle", 0.04);
        playTone(164, 0.13, "sine", 0.028, 0.05);
      } else if (name === "round") {
        [523, 659, 784, 1046].forEach((note, index) => playTone(note, 0.18, "sine", 0.042, index * 0.075));
      } else if (name === "finale") {
        [523, 659, 784, 1046, 1318].forEach((note, index) => playTone(note, 0.22, "sine", 0.045, index * 0.09));
      }
    }

    function showOverlay(title, message, buttonText) {
      titleEl.textContent = title;
      messageEl.textContent = message;
      startButton.textContent = buttonText;
      renderAnimalChooser();
      overlay.classList.remove("hidden");
    }

    function renderAnimalChooser() {
      animalChooser.replaceChildren();
      for (const animal of animals) {
        const unlocked = isAnimalUnlocked(animal);
        const button = document.createElement("button");
        button.type = "button";
        button.className = `animal-option${state.selectedAnimal === animal.id ? " selected" : ""}${unlocked ? "" : " locked"}`;
        button.disabled = !unlocked;
        button.innerHTML = `<strong>${unlocked ? animal.icon : "???"}</strong><span>${unlocked ? animal.name : "Mystery"}</span>`;
        button.setAttribute("aria-label", unlocked ? `Choose ${animal.name}` : `${animal.name} locked until the rainbow is complete`);
        button.addEventListener("click", () => {
          state.selectedAnimal = animal.id;
          renderAnimalChooser();
        });
        animalChooser.append(button);
      }
    }

    function isAnimalUnlocked(animal) {
      return animal.unlock === 0 || animal.unlock <= state.mysteryFound;
    }

    function renderRewards() {
      badgesEl.replaceChildren();
      for (const reward of state.earnedRewards) {
        const badge = document.createElement("div");
        badge.className = "badge";
        badge.textContent = reward.icon;
        badge.title = reward.name;
        badge.setAttribute("aria-label", reward.name);
        badgesEl.append(badge);
      }
    }

    function announceReward(message) {
      rewardToast.textContent = message;
      rewardToast.classList.remove("show");
      void rewardToast.offsetWidth;
      rewardToast.classList.add("show");
    }

    function showPenalty(message) {
      penaltyBurst.textContent = message;
      penaltyBurst.classList.remove("show");
      void penaltyBurst.offsetWidth;
      penaltyBurst.classList.add("show");
      for (const stat of document.querySelectorAll(".stat")) {
        stat.classList.remove("damaged");
        void stat.offsetWidth;
        stat.classList.add("damaged");
      }
    }

    function addFloater(x, y, text, color = "#ffd166", size = 26) {
      state.floaters.push({
        x,
        y,
        text,
        color,
        size,
        age: 0,
        life: 0.95,
        vy: -46
      });
    }

    function checkRewards() {
      for (const reward of rewardMilestones) {
        const alreadyEarned = state.earnedRewards.some((earned) => earned.score === reward.score);
        if (!alreadyEarned && state.score >= reward.score) {
          state.earnedRewards.push(reward);
          renderRewards();
          announceReward(`${reward.name} reward earned!`);
          addSparkles(player.x, player.y - 28, "#75e0a7", 26);
          addFloater(player.x, player.y - 50, reward.name, "#75e0a7", 30);
        }
      }
      if (!state.rainbowComplete && gardenProgress() >= 1) {
        state.rainbowComplete = true;
        state.partyTimer = 3.5;
        state.mysteryFound = Math.min(mysteryAnimalCount, state.mysteryFound + 1);
        const foundAnimal = animals.find((animal) => animal.unlock === state.mysteryFound);
        if (foundAnimal) state.selectedAnimal = foundAnimal.id;
        announceReward(foundAnimal ? `Mystery friend found: ${foundAnimal.name}!` : "Rainbow complete!");
        addFloater(width() / 2, height() * 0.34, "Rainbow Complete!", "#ffd166", 34);
        addSparkles(width() / 2, height() * 0.38, "#ffd166", 60);
        addSparkles(width() / 2, height() * 0.38, "#ff7b9c", 36);
        addSparkles(width() / 2, height() * 0.38, "#78c8ff", 36);
        if (state.mysteryFound >= mysteryAnimalCount) {
          finishAdventure();
        } else {
          startCelebration(false);
          advanceToNextRound(foundAnimal);
        }
      }
    }

    function advanceToNextRound(foundAnimal) {
      state.running = false;
      state.awaitingNextRound = true;
      state.round += 1;
      showOverlay(
        foundAnimal ? `${foundAnimal.name} Found!` : "Mystery Found!",
        `The next rainbow is bigger. Choose an animal for round ${state.round}.`,
        "Next Rainbow"
      );
    }

    function finishAdventure() {
      state.running = false;
      state.gameWon = true;
      state.awaitingNextRound = false;
      startCelebration(true);
      showOverlay("All Friends Found!", "Every mystery animal is out. The garden is complete!", "Play Again");
    }

    function startCelebration(finale) {
      state.celebrationFinal = finale;
      state.celebrationUntil = performance.now() + (finale ? 9000 : 6200);
      playSound(finale ? "finale" : "round");
      requestAnimationFrame(loop);
    }

    function pauseToggle() {
      if (!state.running) return;
      state.paused = !state.paused;
      if (state.paused) {
        showOverlay("Paused", "The garden is waiting right where you left it.", "Resume");
      } else {
        overlay.classList.add("hidden");
        state.lastTime = performance.now();
        requestAnimationFrame(loop);
      }
    }

    function spawnObject() {
      const isShuttle = Math.random() < Math.min(0.1 + state.level * 0.015, 0.22);
      const isMoon = !isShuttle && Math.random() < (state.rainbowComplete ? 0.22 : 0.08);
      const size = isShuttle ? 36 : isMoon ? 36 : 28 + Math.random() * 12;
      const color = flowerPalette[Math.floor(Math.random() * flowerPalette.length)];
      state.objects.push({
        x: 24 + Math.random() * (width() - 48),
        y: -36,
        size,
        speed: isShuttle ? 92 + Math.random() * 36 + state.round * 7 : 68 + Math.random() * 34 + state.round * 6,
        spin: Math.random() * Math.PI * 2,
        spinSpeed: (Math.random() * 2 - 1) * 2.8,
        color,
        type: isShuttle ? "shuttle" : isMoon ? "moon" : "star"
      });
    }

    function spawnObstacle() {
      const fromLeft = Math.random() < 0.5;
      const obstacleWidth = 64 + Math.random() * 36;
      const laneTop = topPlayLimit() + 42;
      const laneBottom = bottomPlayLimit() + 14;
      state.obstacles.push({
        x: fromLeft ? -obstacleWidth : width() + obstacleWidth,
        y: laneTop + Math.random() * Math.max(1, laneBottom - laneTop),
        width: obstacleWidth,
        height: 38,
        speed: (72 + state.round * 8 + Math.random() * 24) * (fromLeft ? 1 : -1),
        hit: false,
        color: flowerPalette[Math.floor(Math.random() * flowerPalette.length)],
        wobble: Math.random() * Math.PI * 2
      });
    }

    function spawnShootingStar() {
      const large = Math.random() < 0.32;
      const fromLeft = Math.random() < 0.5;
      const size = large ? 42 : 30;
      state.objects.push({
        x: fromLeft ? -size : width() + size,
        y: topPlayLimit() + Math.random() * Math.max(1, height() * 0.34),
        size,
        speed: 155 + Math.random() * 35,
        vx: (fromLeft ? 1 : -1) * (150 + Math.random() * 45),
        vy: 65 + Math.random() * 28,
        spin: Math.random() * Math.PI * 2,
        spinSpeed: (fromLeft ? 1 : -1) * 3.4,
        hearts: large ? 2 : 1,
        color: large ? "#ff7b9c" : "#f6f1e8",
        type: "heartStar"
      });
    }

    function applyPenalty(x, y, label = "BUMP! -1 STAR") {
      state.lives -= 1;
      if (state.score > 0) state.score -= 1;
      state.penaltyTimer = 1.05;
      addSparkles(x, y, "#78c8ff", 24);
      addFloater(x, y, "-1 Star", "#78c8ff", 32);
      announceReward("Shuttle bump! The garden lost a little glow.");
      showPenalty(label);
      playSound("bump");
      if (state.lives <= 0) endGame();
    }

    function addSparkles(x, y, color, amount = 10) {
      for (let i = 0; i < amount; i += 1) {
        state.sparkles.push({
          x,
          y,
          vx: (Math.random() - 0.5) * 160,
          vy: (Math.random() - 0.8) * 160,
          life: 0.6 + Math.random() * 0.35,
          age: 0,
          color
        });
      }
    }

    function update(dt) {
      if (keys.has("ArrowLeft") || keys.has("a") || state.touchX < 0) player.x -= player.speed * dt;
      if (keys.has("ArrowRight") || keys.has("d") || state.touchX > 0) player.x += player.speed * dt;
      if (keys.has("ArrowUp") || keys.has("w") || state.touchY < 0) player.y -= player.speed * dt;
      if (keys.has("ArrowDown") || keys.has("s") || state.touchY > 0) player.y += player.speed * dt;
      if (player.targetX !== null) {
        player.x += (player.targetX - player.x) * Math.min(1, dt * 12);
      }
      if (player.targetY !== null) {
        player.y += (player.targetY - player.y) * Math.min(1, dt * 12);
      }
      player.x = Math.min(Math.max(player.x, player.width / 2 + 8), width() - player.width / 2 - 8);
      player.y = Math.min(Math.max(player.y, topPlayLimit()), bottomPlayLimit());

      state.level = state.round;
      state.penaltyTimer = Math.max(0, state.penaltyTimer - dt);
      state.partyTimer = Math.max(0, state.partyTimer - dt);
      state.spawnTimer -= dt;
      state.obstacleTimer -= dt;
      state.shootingTimer -= dt;
      const spawnDelay = Math.max(0.72, 1.24 - state.round * 0.025);
      if (state.spawnTimer <= 0) {
        spawnObject();
        state.spawnTimer = spawnDelay;
      }
      if (state.obstacleTimer <= 0) {
        spawnObstacle();
        state.obstacleTimer = Math.max(1.8, 4.4 - state.round * 0.18);
      }
      if (state.shootingTimer <= 0) {
        spawnShootingStar();
        state.shootingTimer = Math.max(6.8, 10.2 - state.round * 0.18);
      }

      for (const object of state.objects) {
        if (object.type === "heartStar") {
          object.x += object.vx * dt;
          object.y += object.vy * dt;
        } else {
          object.y += object.speed * dt;
        }
        object.spin += object.spinSpeed * dt;
      }

      for (const obstacle of state.obstacles) {
        obstacle.x += obstacle.speed * dt;
      }

      for (const sparkle of state.sparkles) {
        sparkle.age += dt;
        sparkle.x += sparkle.vx * dt;
        sparkle.y += sparkle.vy * dt;
        sparkle.vy += 170 * dt;
      }

      for (const floater of state.floaters) {
        floater.age += dt;
        floater.y += floater.vy * dt;
      }

      state.sparkles = state.sparkles.filter((sparkle) => sparkle.age < sparkle.life);
      state.floaters = state.floaters.filter((floater) => floater.age < floater.life);
      handleCollisions();
      state.objects = state.objects.filter((object) => object.y < height() + 80 && object.x > -120 && object.x < width() + 120);
      state.obstacles = state.obstacles.filter((obstacle) => obstacle.x > -130 && obstacle.x < width() + 130 && !obstacle.hit);
      updateStats();
    }

    function handleCollisions() {
      const px = player.x;
      const py = player.y;
      for (const object of state.objects) {
        if (object.hit) continue;
        const dx = Math.abs(object.x - px);
        const dy = Math.abs(object.y - py);
        if (dx < player.width * 0.45 + object.size * 0.38 && dy < player.height * 0.55 + object.size * 0.4) {
          object.hit = true;
          if (object.type === "star" || object.type === "moon") {
            const value = object.type === "moon" ? 5 : 1;
            state.score += value;
            addSparkles(object.x, object.y, object.type === "moon" ? "#f6f1e8" : object.color, object.type === "moon" ? 26 : 12);
            addFloater(object.x, object.y, object.type === "moon" ? "+5 Moon" : "+1 Star", object.type === "moon" ? "#f6f1e8" : object.color, object.type === "moon" ? 30 : 26);
            playSound(object.type === "moon" ? "moon" : "star");
            if (state.score % 5 === 0) announceReward(`${state.score} stars collected! The rainbow is growing.`);
            checkRewards();
          } else if (object.type === "heartStar") {
            const gained = Math.min(object.hearts, 6 - state.lives);
            state.lives = Math.min(6, state.lives + object.hearts);
            addSparkles(object.x, object.y, "#ff7b9c", object.hearts === 2 ? 42 : 24);
            addFloater(object.x, object.y, object.hearts === 2 ? "+2 Hearts" : "+1 Heart", "#ff7b9c", object.hearts === 2 ? 32 : 28);
            announceReward(gained > 0 ? `Shooting star! +${gained} heart${gained === 1 ? "" : "s"}.` : "Shooting star sparkle!");
            playSound("heart");
          } else {
            applyPenalty(object.x, object.y, "SHUTTLE BUMP! -1 STAR");
          }
        }
      }
      for (const obstacle of state.obstacles) {
        if (obstacle.hit) continue;
        const nearX = Math.abs(obstacle.x - px) < obstacle.width * 0.5 + player.width * 0.35;
        const nearY = Math.abs(obstacle.y - py) < obstacle.height * 0.5 + player.height * 0.55;
        if (nearX && nearY) {
          obstacle.hit = true;
          applyPenalty(obstacle.x, obstacle.y, "SHUTTLE BUMP! -1 STAR");
        }
      }
      state.objects = state.objects.filter((object) => !object.hit);
    }

    function endGame() {
      state.running = false;
      showOverlay("Garden Saved", `You caught ${state.score} star${state.score === 1 ? "" : "s"}.`, "Play Again");
    }

    function gardenProgress() {
      return Math.min(1, state.score / rainbowTarget());
    }

    function rainbowTarget() {
      return 34 + (state.round - 1) * 14;
    }

    function flowerMood() {
      return Math.min(1, state.score / 24);
    }

    function drawRainbow(time) {
      const w = width();
      const h = height();
      const progress = gardenProgress();
      const bands = [
        "#ff5f57",
        "#ff9f43",
        "#ffd166",
        "#75e0a7",
        "#78c8ff",
        "#b390ff"
      ];
      const visibleBands = Math.ceil(progress * bands.length);
      const cx = w * 0.5;
      const cy = h * 0.82;
      const baseRadius = Math.min(w * 0.43, h * 0.58);
      const roundGrowth = (state.round - 1) * 16;
      const arcStart = Math.PI;
      const arcEnd = Math.PI + Math.PI * Math.max(0.035, progress);

      ctx.save();
      ctx.lineCap = "round";
      ctx.globalAlpha = 0.26;
      for (let i = 0; i < bands.length; i += 1) {
        ctx.beginPath();
        ctx.strokeStyle = "rgba(246, 241, 232, 0.32)";
        ctx.lineWidth = 9;
        ctx.arc(cx, cy, baseRadius + roundGrowth - i * 13, Math.PI, Math.PI * 2);
        ctx.stroke();
      }

      ctx.globalAlpha = 0.92;
      for (let i = 0; i < visibleBands; i += 1) {
        const bandProgress = Math.min(1, Math.max(0, progress * bands.length - i));
        const wobble = Math.sin(time * 0.002 + i) * 0.01;
        ctx.beginPath();
        ctx.strokeStyle = bands[i];
        ctx.lineWidth = 10;
        ctx.arc(cx, cy, baseRadius + roundGrowth - i * 13, arcStart, arcStart + (arcEnd - arcStart) * bandProgress + wobble);
        ctx.stroke();
      }
      ctx.restore();
    }

    function drawFlower(x, groundY, scale, mood, color, time, offset) {
      const sway = Math.sin(time * 0.003 + offset) * (3 + mood * 3);
      const stemHeight = 30 + mood * 18;
      const bloomY = groundY - stemHeight;
      const petalCount = 6;
      const petalSize = 8 + mood * 5;
      const faceRadius = 8 + mood * 3;
      const stemBase = stemHeight / scale;

      ctx.save();
      ctx.translate(x + sway, bloomY);
      ctx.scale(scale, scale);

      ctx.strokeStyle = "#75e0a7";
      ctx.lineWidth = 4;
      ctx.beginPath();
      ctx.moveTo(-sway / scale, stemBase);
      ctx.quadraticCurveTo(-sway * 0.4, stemBase * 0.55, 0, 5);
      ctx.stroke();

      ctx.fillStyle = "rgba(117, 224, 167, 0.78)";
      ctx.beginPath();
      ctx.ellipse(-9, stemBase * 0.58, 9, 4.5, -0.55, 0, Math.PI * 2);
      ctx.ellipse(10, stemBase * 0.48, 9, 4.5, 0.55, 0, Math.PI * 2);
      ctx.fill();

      for (let i = 0; i < petalCount; i += 1) {
        const angle = i * Math.PI * 2 / petalCount + time * 0.0008 * mood;
        ctx.save();
        ctx.rotate(angle);
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.ellipse(0, -faceRadius - petalSize * 0.54, petalSize * 0.62, petalSize, 0, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();
      }

      ctx.fillStyle = mood > 0.66 ? "#ffd166" : mood > 0.32 ? "#f7c96b" : "#9aa2aa";
      ctx.beginPath();
      ctx.arc(0, 0, faceRadius, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = "#1b2129";
      ctx.beginPath();
      ctx.arc(-3.5, -2, 1.6 + mood, 0, Math.PI * 2);
      ctx.arc(3.5, -2, 1.6 + mood, 0, Math.PI * 2);
      ctx.fill();

      ctx.strokeStyle = "#1b2129";
      ctx.lineWidth = 2;
      ctx.beginPath();
      if (mood < 0.25) {
        ctx.arc(0, 5.8, 4.5, Math.PI + 0.2, Math.PI * 2 - 0.2);
      } else {
        ctx.arc(0, 1.5, 5.4 + mood * 3, 0.15, Math.PI - 0.15);
      }
      ctx.stroke();
      ctx.restore();
    }

    function drawGarden(time) {
      const w = width();
      const h = height();
      const mood = flowerMood();
      const party = state.rainbowComplete ? 1 : 0;
      const groundY = h - 16;

      ctx.fillStyle = party ? "#4f8c58" : mood > 0.55 ? "#426f4d" : "#365c49";
      ctx.beginPath();
      ctx.moveTo(0, h);
      for (let x = 0; x <= w + 40; x += 40) {
        ctx.lineTo(x, h - 20 - Math.sin(x * 0.035 + time * 0.001) * (9 + mood * 8));
      }
      ctx.lineTo(w, h);
      ctx.closePath();
      ctx.fill();

      const flowers = flowerPalette.map((color, index) => ({
        x: [0.12, 0.27, 0.43, 0.61, 0.78, 0.91][index],
        scale: [0.95, 0.78, 1.08, 0.82, 1.02, 0.74][index],
        color
      }));

      for (let i = 0; i < flowers.length; i += 1) {
        const flower = flowers[i];
        drawFlower(w * flower.x, groundY + (i % 2) * 10, flower.scale, mood, flower.color, time, i * 1.7);
      }
    }

    function drawCloud(x, y, scale, time, offset) {
      const drift = Math.sin(time * 0.0007 + offset) * 7;
      ctx.save();
      ctx.translate(x + drift, y);
      ctx.scale(scale, scale);
      ctx.fillStyle = "rgba(255, 255, 255, 0.82)";
      ctx.beginPath();
      ctx.arc(-24, 6, 18, 0, Math.PI * 2);
      ctx.arc(-5, -4, 24, 0, Math.PI * 2);
      ctx.arc(22, 4, 18, 0, Math.PI * 2);
      ctx.arc(42, 10, 13, 0, Math.PI * 2);
      ctx.rect(-42, 6, 88, 24);
      ctx.fill();
      ctx.fillStyle = "rgba(120, 200, 255, 0.16)";
      ctx.beginPath();
      ctx.ellipse(4, 22, 42, 8, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    function drawBackground(time) {
      const w = width();
      const h = height();
      const penalty = Math.min(1, state.penaltyTimer / 0.55);
      const party = state.rainbowComplete ? 1 : 0;
      const shake = penalty > 0 ? Math.sin(time * 0.08) * 5 * penalty : 0;
      const gradient = ctx.createLinearGradient(0, 0, 0, h);
      gradient.addColorStop(0, party ? "#6bb9ff" : "#5fa8e8");
      gradient.addColorStop(0.48, party ? "#8fd6c4" : "#76c9d1");
      gradient.addColorStop(1, party ? "#87b85e" : "#6c9959");
      ctx.save();
      ctx.translate(shake, 0);
      ctx.fillStyle = gradient;
      ctx.fillRect(-8, 0, w + 16, h);

      ctx.globalAlpha = 0.22 + party * 0.16;
      ctx.fillStyle = "#fff3b0";
      ctx.beginPath();
      ctx.arc(w * 0.83, h * 0.16, 42 + party * 12, 0, Math.PI * 2);
      ctx.fill();
      ctx.globalAlpha = 1;

      drawCloud(w * 0.18, h * 0.14, 0.78, time, 0);
      drawCloud(w * 0.52, h * 0.2, 0.62, time, 2.1);
      drawCloud(w * 0.76, h * 0.1, 0.54, time, 4.2);
      if (party) {
        drawCloud(w * 0.34, h * 0.08, 0.46, time, 6.5);
      }

      for (const star of state.stars) {
        const alpha = 0.28 + party * 0.24 + Math.sin(time * 0.002 + star.pulse) * 0.18;
        ctx.globalAlpha = alpha;
        ctx.fillStyle = "#f6f1e8";
        ctx.beginPath();
        ctx.arc(star.x, star.y, star.r, 0, Math.PI * 2);
        ctx.fill();
      }
      ctx.globalAlpha = 1;

      drawRainbow(time);
      drawGarden(time);
      if (state.partyTimer > 0) {
        ctx.globalAlpha = Math.min(1, state.partyTimer / 2.5);
        for (let i = 0; i < 18; i += 1) {
          const x = (i * 83 + time * 0.05) % (w + 80) - 40;
          const y = 42 + Math.sin(time * 0.004 + i) * 22 + (i % 3) * 24;
          drawStar(x, y, 6 + (i % 3) * 2, time * 0.002 + i, flowerPalette[i % flowerPalette.length]);
        }
        ctx.globalAlpha = 1;
      }
      if (penalty > 0) {
        ctx.globalAlpha = 0.22 * penalty;
        ctx.fillStyle = "#78c8ff";
        ctx.fillRect(-8, 0, w + 16, h);
        ctx.globalAlpha = 1;
      }
      ctx.restore();
    }

    function drawMoon(x, y, radius, rotation) {
      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(Math.sin(rotation) * 0.12);
      ctx.shadowColor = "rgba(246, 241, 232, 0.72)";
      ctx.shadowBlur = 18;
      ctx.fillStyle = "#f6f1e8";
      ctx.beginPath();
      ctx.arc(0, 0, radius, Math.PI * 0.45, Math.PI * 1.55);
      ctx.quadraticCurveTo(radius * 0.42, 0, 0, -radius);
      ctx.fill();
      ctx.shadowBlur = 0;
      ctx.strokeStyle = "rgba(255, 255, 255, 0.65)";
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.arc(0, 0, radius, Math.PI * 0.48, Math.PI * 1.52);
      ctx.stroke();
      ctx.fillStyle = "#ffd166";
      ctx.beginPath();
      ctx.arc(-radius * 0.1, -radius * 0.12, radius * 0.09, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    function drawStar(x, y, radius, rotation, color = "#ffd166") {
      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(rotation);
      ctx.beginPath();
      for (let i = 0; i < 10; i += 1) {
        const angle = -Math.PI / 2 + i * Math.PI / 5;
        const r = i % 2 === 0 ? radius : radius * 0.45;
        ctx.lineTo(Math.cos(angle) * r, Math.sin(angle) * r);
      }
      ctx.closePath();
      ctx.fillStyle = color;
      ctx.shadowColor = color;
      ctx.shadowBlur = 16;
      ctx.fill();
      ctx.shadowBlur = 0;
      ctx.strokeStyle = "rgba(255, 255, 255, 0.55)";
      ctx.lineWidth = 2;
      ctx.stroke();
      ctx.restore();
    }

    function drawShootingHeartStar(object) {
      const radius = object.size * 0.42;
      const trailLength = object.hearts === 2 ? 92 : 66;
      const trailX = object.vx > 0 ? -trailLength : trailLength;
      const trailY = -trailLength * 0.32;
      const gradient = ctx.createLinearGradient(object.x, object.y, object.x + trailX, object.y + trailY);
      gradient.addColorStop(0, "rgba(255, 123, 156, 0.86)");
      gradient.addColorStop(0.45, "rgba(255, 209, 102, 0.42)");
      gradient.addColorStop(1, "rgba(255, 255, 255, 0)");

      ctx.save();
      ctx.lineCap = "round";
      ctx.strokeStyle = gradient;
      ctx.lineWidth = object.hearts === 2 ? 13 : 9;
      ctx.beginPath();
      ctx.moveTo(object.x + trailX, object.y + trailY);
      ctx.lineTo(object.x, object.y);
      ctx.stroke();
      ctx.restore();

      drawStar(object.x, object.y, radius, object.spin, object.color);

      ctx.save();
      ctx.translate(object.x, object.y);
      ctx.fillStyle = "#ff7b9c";
      ctx.strokeStyle = "rgba(255, 255, 255, 0.75)";
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(0, radius * 0.55);
      ctx.bezierCurveTo(-radius * 0.9, -radius * 0.1, -radius * 0.45, -radius * 0.78, 0, -radius * 0.28);
      ctx.bezierCurveTo(radius * 0.45, -radius * 0.78, radius * 0.9, -radius * 0.1, 0, radius * 0.55);
      ctx.fill();
      ctx.stroke();
      ctx.restore();
    }

    function drawCelebration(time) {
      if (time > state.celebrationUntil) return;
      const w = width();
      const h = height();
      const remaining = (state.celebrationUntil - time) / 1000;
      const fade = Math.min(1, remaining / 1.2);
      const intensity = state.celebrationFinal ? 1.45 : 1;
      const bursts = state.celebrationFinal ? 8 : 5;

      ctx.save();
      ctx.globalAlpha = 0.18 * fade;
      ctx.fillStyle = "#fff3b0";
      ctx.fillRect(0, 0, w, h);
      ctx.globalAlpha = 1;

      for (let i = 0; i < bursts; i += 1) {
        const cycle = ((time * 0.00055 + i * 0.23) % 1);
        const cx = w * (0.16 + ((i * 0.19) % 0.72));
        const cy = h * (0.16 + ((i * 0.11) % 0.34));
        const radius = (18 + cycle * 72 * intensity);
        const alpha = Math.max(0, 1 - cycle) * fade;
        const color = flowerPalette[i % flowerPalette.length];
        ctx.globalAlpha = alpha;
        ctx.strokeStyle = color;
        ctx.lineWidth = 3;
        for (let ray = 0; ray < 14; ray += 1) {
          const angle = ray * Math.PI * 2 / 14 + i;
          ctx.beginPath();
          ctx.moveTo(cx + Math.cos(angle) * radius * 0.35, cy + Math.sin(angle) * radius * 0.35);
          ctx.lineTo(cx + Math.cos(angle) * radius, cy + Math.sin(angle) * radius);
          ctx.stroke();
        }
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.arc(cx, cy, 4 + cycle * 2, 0, Math.PI * 2);
        ctx.fill();
      }

      const streaks = state.celebrationFinal ? 18 : 10;
      for (let i = 0; i < streaks; i += 1) {
        const t = (time * 0.00034 + i * 0.071) % 1;
        const x = w + 90 - t * (w + 220);
        const y = h * (0.08 + (i % 7) * 0.08) + Math.sin(time * 0.002 + i) * 16;
        const color = flowerPalette[(i + 2) % flowerPalette.length];
        ctx.globalAlpha = fade * 0.9;
        ctx.strokeStyle = color;
        ctx.lineWidth = i % 3 === 0 ? 8 : 5;
        ctx.lineCap = "round";
        ctx.beginPath();
        ctx.moveTo(x + 70, y - 26);
        ctx.lineTo(x, y);
        ctx.stroke();
        drawStar(x, y, i % 3 === 0 ? 8 : 6, time * 0.004 + i, color);
      }
      ctx.restore();
      ctx.globalAlpha = 1;
    }

    function drawShuttle(x, y, size, rotation, color = "#78c8ff") {
      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(Math.sin(rotation) * 0.16);
      ctx.fillStyle = color;
      ctx.strokeStyle = "rgba(255, 255, 255, 0.55)";
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.ellipse(0, 0, size * 0.62, size * 0.36, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      ctx.fillStyle = "#fff6f4";
      ctx.beginPath();
      ctx.arc(size * 0.1, -size * 0.06, size * 0.14, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      ctx.fillStyle = "#ffd166";
      ctx.beginPath();
      ctx.moveTo(-size * 0.56, 0);
      ctx.lineTo(-size * 0.88, -size * 0.22);
      ctx.lineTo(-size * 0.76, 0);
      ctx.lineTo(-size * 0.88, size * 0.22);
      ctx.closePath();
      ctx.fill();

      ctx.fillStyle = "#ff7b9c";
      ctx.beginPath();
      ctx.ellipse(-size * 0.08, size * 0.28, size * 0.18, size * 0.08, -0.25, 0, Math.PI * 2);
      ctx.ellipse(size * 0.32, size * 0.26, size * 0.16, size * 0.07, 0.25, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = "#1b2129";
      ctx.beginPath();
      ctx.arc(size * 0.06, -size * 0.08, size * 0.025, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    function drawObstacleShuttle(obstacle, time) {
      const wobble = Math.sin(time * 0.006 + obstacle.wobble) * 4;
      const x = obstacle.x;
      const y = obstacle.y + wobble;
      ctx.save();
      ctx.translate(x, y);
      ctx.fillStyle = "rgba(0, 0, 0, 0.22)";
      ctx.beginPath();
      ctx.ellipse(0, obstacle.height * 0.72, obstacle.width * 0.42, 7, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
      drawShuttle(x, y, obstacle.width * 0.55, time * 0.003 + obstacle.wobble, obstacle.color);
    }

    function currentAnimal() {
      return animals.find((animal) => animal.id === state.selectedAnimal) || animals[0];
    }

    function drawRoundAnimal(animal, time) {
      const bob = Math.sin(time * 0.006) * 4;
      const x = player.x;
      const y = player.y + bob;

      ctx.save();
      ctx.translate(x, y);
      ctx.fillStyle = "rgba(0, 0, 0, 0.22)";
      ctx.beginPath();
      ctx.ellipse(0, 34, 34, 8, 0, 0, Math.PI * 2);
      ctx.fill();

      const body = animal.body;
      const accent = animal.accent;
      ctx.strokeStyle = "rgba(87, 54, 64, 0.28)";
      ctx.lineWidth = 2;

      if (animal.id === "unicorn") {
        ctx.fillStyle = "#ffd166";
        ctx.beginPath();
        ctx.moveTo(0, -51);
        ctx.lineTo(-7, -24);
        ctx.lineTo(7, -24);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        ctx.fillStyle = "#ff7b9c";
        ctx.beginPath();
        ctx.ellipse(-13, -20, 6, 18, -0.45, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillStyle = "#b390ff";
        ctx.beginPath();
        ctx.ellipse(13, -20, 6, 18, 0.45, 0, Math.PI * 2);
        ctx.fill();
      } else if (animal.id === "kitty" || animal.id === "fox") {
        ctx.fillStyle = body;
        ctx.beginPath();
        ctx.moveTo(-18, -19);
        ctx.lineTo(-6, -42);
        ctx.lineTo(2, -17);
        ctx.moveTo(18, -19);
        ctx.lineTo(6, -42);
        ctx.lineTo(-2, -17);
        ctx.fill();
        ctx.stroke();
      } else if (animal.id === "pup") {
        ctx.fillStyle = accent;
        ctx.beginPath();
        ctx.ellipse(-21, -14, 9, 20, -0.45, 0, Math.PI * 2);
        ctx.ellipse(21, -14, 9, 20, 0.45, 0, Math.PI * 2);
        ctx.fill();
      } else {
        ctx.fillStyle = animal.id === "panda" ? "#1b2129" : body;
        ctx.beginPath();
        ctx.arc(-16, -24, 10, 0, Math.PI * 2);
        ctx.arc(16, -24, 10, 0, Math.PI * 2);
        ctx.fill();
      }

      ctx.fillStyle = body;
      ctx.beginPath();
      ctx.ellipse(0, 12, 26, 23, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      ctx.beginPath();
      ctx.arc(0, -7, 23, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      if (animal.id === "panda") {
        ctx.fillStyle = "#1b2129";
        ctx.beginPath();
        ctx.ellipse(-9, -9, 7, 9, -0.35, 0, Math.PI * 2);
        ctx.ellipse(9, -9, 7, 9, 0.35, 0, Math.PI * 2);
        ctx.fill();
      }

      if (animal.id === "fox") {
        ctx.fillStyle = accent;
        ctx.beginPath();
        ctx.moveTo(-14, 0);
        ctx.lineTo(0, 12);
        ctx.lineTo(14, 0);
        ctx.quadraticCurveTo(0, 8, -14, 0);
        ctx.fill();
      }

      if (animal.id === "unicorn") {
        ctx.fillStyle = "#b390ff";
        ctx.beginPath();
        ctx.arc(-15, -21, 5, 0, Math.PI * 2);
        ctx.arc(-10, -25, 5, 0, Math.PI * 2);
        ctx.arc(-4, -24, 5, 0, Math.PI * 2);
        ctx.fill();

        ctx.fillStyle = "#fff6f4";
        ctx.beginPath();
        ctx.ellipse(0, 0, 13, 10, 0, 0, Math.PI * 2);
        ctx.fill();
      }

      ctx.fillStyle = "#1b2129";
      ctx.beginPath();
      ctx.arc(-8, -9, 2.5, 0, Math.PI * 2);
      ctx.arc(8, -9, 2.5, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = animal.id === "panda" ? "#1b2129" : "#ff7b9c";
      ctx.beginPath();
      ctx.ellipse(0, -1, 4.2, 3, 0, 0, Math.PI * 2);
      ctx.fill();

      ctx.strokeStyle = "#1b2129";
      ctx.lineWidth = 1.8;
      ctx.beginPath();
      ctx.moveTo(0, 2);
      ctx.lineTo(0, 6);
      ctx.moveTo(0, 6);
      ctx.quadraticCurveTo(-5, 10, -10, 7);
      ctx.moveTo(0, 6);
      ctx.quadraticCurveTo(5, 10, 10, 7);
      ctx.stroke();

      ctx.fillStyle = animal.id === "unicorn" ? "#ffd166" : "#ffb3c2";
      ctx.beginPath();
      ctx.arc(-17, 0, 4.8, 0, Math.PI * 2);
      ctx.arc(17, 0, 4.8, 0, Math.PI * 2);
      ctx.fill();

      if (animal.id === "pup" || animal.id === "fox" || animal.id === "unicorn") {
        ctx.fillStyle = animal.id === "fox" ? accent : body;
        ctx.beginPath();
        ctx.ellipse(24, 16, animal.id === "unicorn" ? 13 : 11, 7, 0.6, 0, Math.PI * 2);
        ctx.fill();
        if (animal.id === "unicorn") {
          ctx.fillStyle = "#ff7b9c";
          ctx.beginPath();
          ctx.ellipse(31, 12, 5, 8, 0.6, 0, Math.PI * 2);
          ctx.fill();
        }
      } else {
        ctx.fillStyle = animal.id === "panda" ? "#1b2129" : accent;
        ctx.beginPath();
        ctx.arc(23, 16, 8.5, 0, Math.PI * 2);
        ctx.fill();
      }
      ctx.restore();
    }

    function drawPlayer(time) {
      const animal = currentAnimal();
      if (animal.id !== "bunny") {
        drawRoundAnimal(animal, time);
        return;
      }
      const bob = Math.sin(time * 0.006) * 4;
      const x = player.x;
      const y = player.y + bob;

      ctx.save();
      ctx.translate(x, y);
      ctx.fillStyle = "rgba(0, 0, 0, 0.25)";
      ctx.beginPath();
      ctx.ellipse(0, 34, 36, 9, 0, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = "#fff6f4";
      ctx.strokeStyle = "rgba(87, 54, 64, 0.28)";
      ctx.lineWidth = 2;

      ctx.save();
      ctx.rotate(-0.25);
      ctx.beginPath();
      ctx.ellipse(-15, -28, 8, 24, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();
      ctx.fillStyle = "#ffb3c2";
      ctx.beginPath();
      ctx.ellipse(-15, -28, 3.8, 16, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();

      ctx.fillStyle = "#fff6f4";
      ctx.save();
      ctx.rotate(0.25);
      ctx.beginPath();
      ctx.ellipse(15, -28, 8, 24, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();
      ctx.fillStyle = "#ffb3c2";
      ctx.beginPath();
      ctx.ellipse(15, -28, 3.8, 16, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();

      ctx.fillStyle = "#fff6f4";
      ctx.beginPath();
      ctx.ellipse(0, 11, 27, 24, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      ctx.beginPath();
      ctx.arc(0, -5, 23, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      ctx.fillStyle = "#1b2129";
      ctx.beginPath();
      ctx.arc(-8, -8, 2.4, 0, Math.PI * 2);
      ctx.arc(8, -8, 2.4, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = "#ff7b9c";
      ctx.beginPath();
      ctx.ellipse(0, -1, 4.4, 3.2, 0, 0, Math.PI * 2);
      ctx.fill();

      ctx.strokeStyle = "#1b2129";
      ctx.lineWidth = 1.8;
      ctx.beginPath();
      ctx.moveTo(0, 2);
      ctx.lineTo(0, 6);
      ctx.moveTo(0, 6);
      ctx.quadraticCurveTo(-5, 10, -10, 7);
      ctx.moveTo(0, 6);
      ctx.quadraticCurveTo(5, 10, 10, 7);
      ctx.stroke();

      ctx.fillStyle = "#ff7b9c";
      ctx.beginPath();
      ctx.arc(-17, 0, 5, 0, Math.PI * 2);
      ctx.arc(17, 0, 5, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = "#f2e8df";
      ctx.beginPath();
      ctx.arc(23, 15, 9, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    function drawSparkles() {
      for (const sparkle of state.sparkles) {
        const t = 1 - sparkle.age / sparkle.life;
        ctx.globalAlpha = Math.max(0, t);
        ctx.fillStyle = sparkle.color;
        ctx.beginPath();
        ctx.arc(sparkle.x, sparkle.y, 2 + t * 3, 0, Math.PI * 2);
        ctx.fill();
      }
      ctx.globalAlpha = 1;
    }

    function drawFloaters() {
      ctx.save();
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      for (const floater of state.floaters) {
        const t = 1 - floater.age / floater.life;
        ctx.globalAlpha = Math.max(0, t);
        ctx.font = `900 ${floater.size}px Avenir, system-ui, sans-serif`;
        ctx.lineWidth = 5;
        ctx.strokeStyle = "rgba(16, 19, 24, 0.82)";
        ctx.fillStyle = floater.color;
        ctx.strokeText(floater.text, floater.x, floater.y);
        ctx.fillText(floater.text, floater.x, floater.y);
      }
      ctx.restore();
      ctx.globalAlpha = 1;
    }

    function draw(time) {
      drawBackground(time);
      for (const obstacle of state.obstacles) {
        drawObstacleShuttle(obstacle, time);
      }
      for (const object of state.objects) {
        if (object.type === "star") drawStar(object.x, object.y, object.size * 0.5, object.spin, object.color);
        else if (object.type === "moon") drawMoon(object.x, object.y, object.size * 0.48, object.spin);
        else if (object.type === "heartStar") drawShootingHeartStar(object);
        else drawShuttle(object.x, object.y, object.size, object.spin, object.color);
      }
      drawPlayer(time);
      drawSparkles();
      drawFloaters();
      drawCelebration(time);
    }

    function loop(now) {
      if (!state.running || state.paused) {
        if (!state.paused && now <= state.celebrationUntil) {
          draw(now);
          requestAnimationFrame(loop);
        }
        return;
      }
      const dt = Math.min(0.033, (now - state.lastTime) / 1000 || 0);
      state.lastTime = now;
      update(dt);
      draw(now);
      if (state.running) requestAnimationFrame(loop);
    }

    window.addEventListener("resize", resize);
    if (window.visualViewport) {
      window.visualViewport.addEventListener("resize", resize);
    }

    window.addEventListener("orientationchange", () => {
      window.setTimeout(resize, 250);
    });

    window.addEventListener("keydown", (event) => {
      if (["ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", " ", "a", "d", "w", "s"].includes(event.key)) event.preventDefault();
      if (event.key === " ") pauseToggle();
      keys.add(event.key);
    });
    window.addEventListener("keyup", (event) => keys.delete(event.key));
    window.addEventListener("contextmenu", (event) => event.preventDefault());

    function canvasPointFromPointer(event) {
      const rect = canvas.getBoundingClientRect();
      return {
        x: event.clientX - rect.left,
        y: event.clientY - rect.top
      };
    }

    canvas.addEventListener("pointerdown", (event) => {
      event.preventDefault();
      canvas.setPointerCapture(event.pointerId);
      const point = canvasPointFromPointer(event);
      player.targetX = point.x;
      player.targetY = point.y;
    });
    canvas.addEventListener("pointermove", (event) => {
      event.preventDefault();
      if (event.buttons || event.pointerType === "touch") {
        const point = canvasPointFromPointer(event);
        player.targetX = point.x;
        player.targetY = point.y;
      }
    });
    canvas.addEventListener("pointerup", () => {
      player.targetX = null;
      player.targetY = null;
    });
    canvas.addEventListener("pointercancel", () => {
      player.targetX = null;
      player.targetY = null;
    });

    function bindMoveButton(button, axis, direction) {
      const start = (event) => {
        event.preventDefault();
        if (axis === "x") state.touchX = direction;
        else state.touchY = direction;
        player.targetX = null;
        player.targetY = null;
        button.classList.add("pressed");
        button.setPointerCapture(event.pointerId);
      };
      const stop = (event) => {
        event.preventDefault();
        if (axis === "x" && state.touchX === direction) state.touchX = 0;
        if (axis === "y" && state.touchY === direction) state.touchY = 0;
        button.classList.remove("pressed");
      };
      button.addEventListener("pointerdown", start);
      button.addEventListener("pointerup", stop);
      button.addEventListener("pointercancel", stop);
      button.addEventListener("lostpointercapture", () => {
        if (axis === "x" && state.touchX === direction) state.touchX = 0;
        if (axis === "y" && state.touchY === direction) state.touchY = 0;
        button.classList.remove("pressed");
      });
    }

    bindMoveButton(touchLeft, "x", -1);
    bindMoveButton(touchRight, "x", 1);
    bindMoveButton(touchUp, "y", -1);
    bindMoveButton(touchDown, "y", 1);
    touchPause.addEventListener("click", pauseToggle);
    soundToggle.addEventListener("click", () => {
      state.soundOn = !state.soundOn;
      if (state.soundOn) {
        ensureAudio();
        playTone(523, 0.1, "sine", 0.035);
        playTone(659, 0.12, "sine", 0.03, 0.06);
      }
      updateSoundToggle();
    });

    startButton.addEventListener("click", () => {
      if (state.soundOn) ensureAudio();
      if (state.paused) pauseToggle();
      else if (state.awaitingNextRound) beginRound(false);
      else startGame();
    });

    renderAnimalChooser();
    updateSoundToggle();
    resize();
    draw(performance.now());
  </script>
</body>
</html>
