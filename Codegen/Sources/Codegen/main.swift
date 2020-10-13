import Foundation
import ApolloCodegenLib

let parentFolderOfScriptFile = FileFinder.findParentFolder()
let sourceRootURL = parentFolderOfScriptFile
    .apollo.parentFolderURL() // Result: Sources folder
    .apollo.parentFolderURL() // Result: Codegen folder
    .apollo.parentFolderURL() // Result: MyProject source root folder

let cliFolderURL = sourceRootURL
    .apollo.childFolderURL(folderName: "Codegen")
    .apollo.childFolderURL(folderName: "ApolloCLI")

let endpoint = URL(string: "https://api.github.com/graphql")!

let output = sourceRootURL
    .apollo.childFolderURL(folderName:"graphql")

let headers = [
    "Authorization: Bearer da481081a86470ad15685f437127ccab200af429",
    "Accept: application/vnd.github.merge-info-preview+json,application/vnd.github.antiope-preview+json,application/vnd.github.shadow-cat-preview+json,application/vnd.github.echo-preview+json,application/vnd.github.vixen-preview+json,application/vnd.github.starfox-preview+json",
    "GraphQL-Features: pe_mobile",
]

let schemaDownloadOptions = ApolloSchemaOptions(
    endpointURL: endpoint,
    headers: headers,
    outputFolderURL: output
)

do {
  try ApolloSchemaDownloader.run(with: cliFolderURL, options: schemaDownloadOptions)
} catch {
  exit(1)
}
