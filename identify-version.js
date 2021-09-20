const HTTP = require("https");
const semver = require("semver");

const NodeMirror = "https://nodejs.org/dist/";

const getBody = (url, opts) => new Promise((resolve, reject) => {
    HTTP.get(url, opts || {}, res => {
        let body = "";
        res.on("data", data => {
            body += String(data);
        });
        res.on("end", () => resolve(body));
        res.on("error", reject);
    });
});

(async () => {
    if (process.argv.length < 3) throw new Error("Insufficient arguments.");

    const version = process.argv[2];
    const matcher = "lts".localeCompare(version, undefined, {sensitivity: 'accent'}) === 0
        ? it => it.lts
        : it => semver.satisfies(it.version, version);

    const versionsBody = await getBody(`${NodeMirror}index.json`);
    const versions = JSON.parse(versionsBody);

    const matched = versions.find(matcher);

    if (matched === undefined) throw new Error(`Unable to find a matching version for: ${version}`);

    console.log(matched.version);
})().catch(error => {
    console.error(error);
    process.exitCode = 1;
})
