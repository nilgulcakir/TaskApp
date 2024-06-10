//
//  QRScannerVC.swift
//  TaskApp
//
//  Created by Nilgul Cakir on 2.06.2024.
//

import UIKit
import QRCodeReader

protocol QRScannerDelegate: AnyObject {
    func didScanQRCode(value: String)
}

class QRScannerVC: UIViewController, QRCodeReaderViewControllerDelegate {

    var reader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    var onDismiss: (() -> Void)?
    weak var delegate: QRScannerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        reader.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(reader, animated: true, completion: nil)
    }

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        delegate?.didScanQRCode(value: result.value)
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

}

