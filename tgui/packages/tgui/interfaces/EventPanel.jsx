import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const EventPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    event_list = [],
    end_time,
    vote_in_progress,
    previous_events,
    admin_mode,
    show_votes,
    next_vote_time,
    next_low_chaos_time,
  } = data;
  return (
    <Window title={'Event Panel'} width={470} height={500} theme={'ntos'}>
      <Window.Content>
        <Stack vertical fill>
          {!!admin_mode && (
            <Stack.Item>
              <Section title={'Event Control'}>
                <NoticeBox color="blue">
                  {'Next event vote in ' +
                    toFixed(next_vote_time, 0) +
                    ' seconds.'}
                </NoticeBox>
                <NoticeBox color="green">
                  {'Next event in ' +
                    toFixed(next_low_chaos_time, 0) +
                    ' seconds.'}
                </NoticeBox>
                <Button
                  icon="plus"
                  content="Start Admin Vote"
                  tooltip="This will start an admin vote of events below high intensity."
                  disabled={vote_in_progress}
                  onClick={() => act('start_vote_admin')}
                />
                <Button
                  icon="plus"
                  content="Start Admin Chaos Vote"
                  tooltip="This will start an admin vote of events above low intensity."
                  color="average"
                  disabled={vote_in_progress}
                  onClick={() => act('start_vote_admin_chaos')}
                />
                <Button
                  icon="user-plus"
                  content="Start Player Vote"
                  tooltip="This will start a vote of events below high intensity."
                  disabled={vote_in_progress}
                  onClick={() => act('start_player_vote')}
                />
                <Button
                  icon="user-plus"
                  content="Start Public Chaos Vote"
                  tooltip="This will start a vote of events above low intensity."
                  color="average"
                  disabled={vote_in_progress}
                  onClick={() => act('start_player_vote_chaos')}
                />
                <Button
                  icon="stopwatch"
                  content="End Vote"
                  tooltip="End the current vote and execute the winning event."
                  disabled={!vote_in_progress}
                  onClick={() => act('end_vote')}
                />
                <Button
                  icon="ban"
                  content="Cancel Vote"
                  tooltip="Cancel the current vote and reset the voting system."
                  disabled={!vote_in_progress}
                  onClick={() => act('cancel_vote')}
                />
                <Button
                  icon="clock"
                  content="Reschedule Next Event Vote"
                  tooltip="Reschedule the next event vote."
                  onClick={() => act('reschedule')}
                />
                <Button
                  icon="clock"
                  content="Reschedule Next Event"
                  tooltip="Reschedule the next event."
                  onClick={() => act('reschedule_low_chaos')}
                />
              </Section>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section
              scrollable
              fill
              grow
              title={
                vote_in_progress
                  ? 'Available Events (' + toFixed(end_time) + ' seconds) '
                  : 'Available Events'
              }
            >
              {vote_in_progress ? (
                <LabeledList>
                  {event_list.map((event) => (
                    <LabeledList.Item
                      label={event.name}
                      key={event.name}
                      buttons={
                        <Button
                          color={event.self_vote ? 'good' : 'blue'}
                          icon="vote-yea"
                          content="Vote"
                          onClick={() =>
                            act('register_vote', {
                              event_ref: event.ref,
                            })
                          }
                        />
                      }
                    >
                      {!!show_votes || (!!admin_mode && event.votes)}
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              ) : (
                <NoticeBox>No vote in progress.</NoticeBox>
              )}
            </Section>
          </Stack.Item>
          {!!admin_mode && (
            <Stack.Item>
              <Section
                scrollable
                grow
                fill
                height="100px"
                title="Previous Events"
              >
                {previous_events.length > 0 ? (
                  <LabeledList>
                    {previous_events.map((event) => (
                      <LabeledList.Item label="Event" key={event}>
                        {event}
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                ) : (
                  <NoticeBox>No previous events.</NoticeBox>
                )}
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
