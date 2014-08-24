require 'spec_helper'
require 'msf/core/encoded_payload'

describe Msf::EncodedPayload do
  PAYLOAD_FRAMEWORK = Msf::Simple::Framework.create(
    :module_types => [::Msf::MODULE_PAYLOAD, ::Msf::MODULE_ENCODER, ::Msf::MODULE_NOP],
    'DisableDatabase' => true,
    'DisableLogging' => true
  )

  let(:framework) { PAYLOAD_FRAMEWORK }
  let(:payload) { 'linux/x86/shell_reverse_tcp' }
  let(:pinst) { framework.payloads.create(payload) }

  subject(:encoded_payload) do
    described_class.new(framework, pinst, {})
  end

  describe '.create' do

    context 'when passed a valid payload instance' do

      subject(:created_payload) do
        described_class.create(pinst)
      end

      # don't ever actually generate payload bytes
      before { Msf::EncodedPayload.any_instance.stub(:generate) }

      it 'returns an Msf::EncodedPayload instance' do
        expect(created_payload).to be_an(Msf::EncodedPayload)
      end

    end

  end

  describe '#arch' do
    context 'when payload is linux/x86 reverse tcp' do
      let(:payload) { 'linux/x86/shell_reverse_tcp' }

      it 'returns ["X86"]' do
        expect(encoded_payload.arch).to eq [ARCH_X86]
      end
    end

    context 'when payload is linux/x64 reverse tcp' do
      let(:payload) { 'linux/x64/shell_reverse_tcp' }

      it 'returns ["X86_64"]' do
        expect(encoded_payload.arch).to eq [ARCH_X86_64]
      end
    end
  end
end
