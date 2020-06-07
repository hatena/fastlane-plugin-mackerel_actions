describe Fastlane::Actions::MackerelActionsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The mackerel_actions plugin is working!")

      Fastlane::Actions::MackerelActionsAction.run(nil)
    end
  end
end
