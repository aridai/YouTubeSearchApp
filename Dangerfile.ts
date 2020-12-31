import { markdown, fail } from 'danger';
import { readFileSync } from 'fs';

//  Dart Format Report
function parseFormattedFilePath(line: string): string | null {
    const result = line.match(/^Formatted (.+).dart$/);
    if (result == null) return null; else return `${result[1]}.dart`;
}

const dartFormatReport = readFileSync('dart_format_report.txt', 'utf-8');
const formattedFilePaths = dartFormatReport.split('\n').map(parseFormattedFilePath).filter(path => path != null);

markdown('## Dart Format Report\n');

if (formattedFilePaths.length != 0) {
    markdown(`${formattedFilePaths.length} issue(s) found.\n`);
    for (var path of formattedFilePaths) markdown(`* ${path}`);

    fail(`Dart Format Report: ${formattedFilePaths.length} issue(s) found.`);
}


//  Flutter Analyze Report
interface Issue { level: string; message: string; file: string; rule: string; }

function parseIssueLine(line: string): Issue | null {
    const result = line.match(/(\s*)(info|warning|error) • (.+) • (.+) • (.+)/);
    if (result == null) return null;
    else return { level: result[2], message: result[3], file: result[4], rule: result[5] };
}

const report = readFileSync('flutter_analyze_report.txt', 'utf-8');
const issues = report.split('\n').map(parseIssueLine).filter(issue => issue != null);

markdown('## Flutter Analyzer Report\n');

if (issues.length != 0) {
    var table = '| Level | Message | File | Rule |\n|:---|:---|:---|:---|\n';

    for (var issue of issues) {
        const ruleLink = `[${issue.rule}](https://dart-lang.github.io/linter/lints/${issue.rule}.html)`;
        table += `| ${issue.level} | ${issue.message} | ${issue.file} | ${ruleLink} |\n`;
    }

    markdown(`${issues.length} issue(s) found.\n`);
    markdown(table);

    fail(`Flutter Analyze Report: ${issues.length} issue(s) found.`);
}
