//
//  TaskEditorView.swift
//  shked
//
//  Created by Максим Лейхнер on 12.03.2023.
//

import SwiftUI
import PhotosUI
import QuickLookThumbnailing
import FilePicker

struct TaskEditorView: View {
    
    @State var text: String = ""
    @State var photosLoaded: [Data] = []
    @State var photosSelection: [PhotosPickerItem] = []
    @State var attachments: [Attachment] = []
    @State var dataAmount: Int = 0
    let maxDataAmount: Int = 52428800

    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 30){
                Text("Задание")
                    .font(.custom("Unbounded", size: 32))
                    .fontWeight(.bold)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "multiply")
                        .font(.system(size: 24))
                }
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 24))
                }

            }
            Divider()
            TextEditor(text: $text)
                .font(.custom("PT Sans", size: text.count > 100 ? 18 : 24))
                .focused($focus)
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach (photosLoaded, id: \.self) {
                        data in
                        ImageThumbnail(imageData: data)
                    }
                }
                .onChange(of: photosSelection) { _ in
                    photosLoaded.removeAll()
                    dataAmount = 0
                    photosSelection.forEach { selection in
                        selection.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let result?):
                                let image = UIImage(data: result)
                                let data = image?.jpegData(compressionQuality: 0.3)
                                dataAmount += data?.count ?? 0
                                photosLoaded.append(data!)
                                break
                            case .failure(let error):
                                print(error)
                                break
                            case .success(.none):
                                print("Nil was returned")
                                break
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
            }
            .padding(.horizontal, -18)
            VStack {
                Divider()
                HStack (spacing: 20){
                    PhotosPicker(selection: $photosSelection, matching: .images) {
                        Image(systemName: "photo")
                    }
                    FilePicker(types: allUTITypes(), allowMultiple: true) {
                        urls in
                        urls.forEach { url in
                            generateThumbnailRepresentations(url)
                        }
                    } label: {
                        Image(systemName: "doc")
                    }
                    Spacer()
                    if dataAmount != 0 {
                        Text("\(String(format: "%.2f", Float(dataAmount) / 1048576)) MB из \(maxDataAmount / 1048576) MB")
                            .font(.custom("PT Root UI VF", size: 16))
                    }
                    Spacer()
                    Button{
                        focus.toggle()
                    } label: {
                        Image(systemName: focus ? "chevron.down" : "chevron.up")
                    }
                }
                .font(.system(size: 24))
                .padding(.bottom, 9)
                .padding(.top, 2)
            }
        }
        .padding([.horizontal, .top], 18)
        .onAppear {
            focus = true
        }
    }
    
    func generateThumbnailRepresentations(_ url: URL) {
        
        let size: CGSize = CGSize(width: 84, height: 112)
        let scale = UIScreen.main.scale
        
        // Create the thumbnail request.
        let request = QLThumbnailGenerator.Request(fileAt: url,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .all)
        
        // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
        let generator = QLThumbnailGenerator.shared
        generator.generateBestRepresentation(for: request) { (thumbnail, error) in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    print("error while loading \(url.absoluteString)")
                } else {
                    self.photosLoaded.append((thumbnail?.uiImage.jpegData(compressionQuality: 0.7))!)
                }
            }
        }
    }
}

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditorView()
    }
}

enum ImageState {
    case empty, loading (Progress), success (Image), failure (Error)
}

func allUTITypes() -> [UTType] {
        let types : [UTType] =
            [.item,
             .content,
             .compositeContent,
             .diskImage,
             .data,
             .directory,
             .resolvable,
             .symbolicLink,
             .executable,
             .mountPoint,
             .aliasFile,
             .urlBookmarkData,
             .url,
             .fileURL,
             .text,
             .plainText,
             .utf8PlainText,
             .utf16ExternalPlainText,
             .utf16PlainText,
             .delimitedText,
             .commaSeparatedText,
             .tabSeparatedText,
             .utf8TabSeparatedText,
             .rtf,
             .html,
             .xml,
             .yaml,
             .sourceCode,
             .assemblyLanguageSource,
             .cSource,
             .objectiveCSource,
             .swiftSource,
             .cPlusPlusSource,
             .objectiveCPlusPlusSource,
             .cHeader,
             .cPlusPlusHeader]

        let types_1: [UTType] =
            [.script,
             .appleScript,
             .osaScript,
             .osaScriptBundle,
             .javaScript,
             .shellScript,
             .perlScript,
             .pythonScript,
             .rubyScript,
             .phpScript,
             .makefile, //'makefile' is only available in iOS 15.0 or newer
             .json,
             .propertyList,
             .xmlPropertyList,
             .binaryPropertyList,
             .pdf,
             .rtfd,
             .flatRTFD,
             .webArchive,
             .image,
             .jpeg,
             .tiff,
             .gif,
             .png,
             .icns,
             .bmp,
             .ico,
             .rawImage,
             .svg,
             .livePhoto,
             .heif,
             .heic,
             .webP,
             .threeDContent,
             .usd,
             .usdz,
             .realityFile,
             .sceneKitScene,
             .arReferenceObject,
             .audiovisualContent]

        let types_2: [UTType] =
            [.movie,
             .video,
             .audio,
             .quickTimeMovie,
             UTType("com.apple.quicktime-image"),
             .mpeg,
             .mpeg2Video,
             .mpeg2TransportStream,
             .mp3,
             .mpeg4Movie,
             .mpeg4Audio,
             .appleProtectedMPEG4Audio,
             .appleProtectedMPEG4Video,
             .avi,
             .aiff,
             .wav,
             .midi,
             .playlist,
             .m3uPlaylist,
             .folder,
             .volume,
             .package,
             .bundle,
             .pluginBundle,
             .spotlightImporter,
             .quickLookGenerator,
             .xpcService,
             .framework,
             .application,
             .applicationBundle,
             .applicationExtension,
             .unixExecutable,
             .exe,
             .systemPreferencesPane,
             .archive,
             .gzip,
             .bz2,
             .zip,
             .appleArchive,
             .spreadsheet,
             .presentation,
             .database,
             .message,
             .contact,
             .vCard,
             .toDoItem,
             .calendarEvent,
             .emailMessage,
             .internetLocation,
             .internetShortcut,
             .font,
             .bookmark,
             .pkcs12,
             .x509Certificate,
             .epub,
             .log]
                .compactMap({ $0 })

        return types + types_1 + types_2
    }
