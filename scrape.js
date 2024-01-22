const axios = require("axios");

async function verses() {
  for (let i = 1; i <= 114; i++) {
    try {
      const res = await axios.get(`https://equran.id/api/v2/surat/${i}`);
      await Bun.write(
        `./assets/verses/surah-${i}.json`,
        JSON.stringify(res.data.data)
      );
      await new Promise((ress) => setTimeout(() => ress(), 300));
      console.log(`STATUS: surah ${i} scraped`);
    } catch (error) {
      console.log(`STATUS: surah ${i} failed to scrape`, error.message);
    }
  }
}

async function interpretation() {
    for (let i = 47; i <= 114; i++) {
      try {
        const res = await axios.get(`https://equran.id/api/v2/tafsir/${i}`);
        await Bun.write(
          `./assets/data/interpretations/tafsir-${i}.json`,
          JSON.stringify(res.data.data)
        );
        await new Promise((ress) => setTimeout(() => ress(), 500));
        console.log(`STATUS: tafsir ${i} scraped`);
      } catch (error) {
        console.log(`STATUS: tafsir ${i} failed to scrape`, error.message);
      }
    }
}
 
interpretation();
