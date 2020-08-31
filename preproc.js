const { readFileSync } = require('fs')
const path = require('path')

const LINE_SEPARATOR = '\n'
const FILE_REF_REGEX = /^FILE: (.+)$/
const CODE_FILE_REF_REGEX = /^CODE: (\S+) (\S+)\s*(\d\S+|editable)?\s*(class=(.*))?$/

const escapeHtml = unsafe =>
  unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;")

const codeTemplate = (code, lang = 'javascript', { editable, dataLineNumbers, cssClass }) => (
`<pre>
  <code class='lang-${lang} hljs ${cssClass}' data-trim ${dataLineNumbers ? `data-line-numbers=${dataLineNumbers}` : '' } ${editable ? 'contenteditable' : ''}>${escapeHtml(code)}</code>
</pre>`)

const isFileReference = line => FILE_REF_REGEX.test(line)
const isCodeFileReference = line => CODE_FILE_REF_REGEX.test(line)
const loadFileContent = (line, basePath) => {
  const filePath = line.match(FILE_REF_REGEX)[1]

  return preprocess(readFileSync(path.join(basePath, filePath), 'utf8'))
}

const loadCodeFileContent = (line, basePath) => {
  const filePath = line.match(CODE_FILE_REF_REGEX)[1]
  const lang = line.match(CODE_FILE_REF_REGEX)[2]
  const prop = line.match(CODE_FILE_REF_REGEX)[3]
  const cssClass = line.match(CODE_FILE_REF_REGEX)[4]
  const props = {
    editable: prop === 'editable',
    dataLineNumbers: prop !== 'editable' ? prop : undefined,
    cssClass: cssClass ? line.match(CODE_FILE_REF_REGEX)[5]:''
  }
  const code = readFileSync(path.join(basePath, filePath), 'utf8')

  return codeTemplate(code, lang, props)
}

const preprocess = (markdown) =>
  markdown
    .split(LINE_SEPARATOR)
    .map(line => {
      if (isFileReference(line)) return loadFileContent(line, 'src/sections')
      else if (isCodeFileReference(line)) return loadCodeFileContent(line, 'src/examples')
      return line
    })
    .join(LINE_SEPARATOR)

module.exports = preprocess
