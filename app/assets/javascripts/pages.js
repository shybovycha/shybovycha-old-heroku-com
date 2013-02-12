jQuery(document).ready(function() {
    var converter = Markdown.getSanitizingConverter();

    converter.hooks.chain("preBlockGamut", function (text, rbg) {
        return text.replace(/^ {0,3}""" *\n((?:.*?\n)+?) {0,3}""" *$/gm, function (whole, inner) {
            return "<blockquote>" + rbg(inner) + "</blockquote>\n";
        });
    });

    var help = function () {
        alert("Do you need help?");
    };

    var options = {
        helpButton: {
            handler: help
        },
        strings: {
            quoteexample: "whatever you're quoting, put it right here"
        }
    };

    var editor = new Markdown.Editor(converter, '', options);

    editor.run();

    SyntaxHighlighter.config['tagName'] = 'pre';
    SyntaxHighlighter.config['html-script'] = true;
    SyntaxHighlighter.all();
});