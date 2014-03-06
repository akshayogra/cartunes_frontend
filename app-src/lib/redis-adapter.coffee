'use strict'

class RedisAdapter
  constructor: (redis, prefix = '') ->
    @redis  = redis
    @prefix = prefix

  key: ->
    args = []
    args.push arguments...
    "#{@prefix}#{args.join ':'}"

  #
  # Adds a track to the queue / pool. If already added it increments the number
  # of votes on it.
  #
  # @param Object   track
  # @param Function done
  #
  voteTrack: (track, clientId, done) ->
    # prefix:votes:uri clientid 1
    # prefix:tracks uri json
    onExec = (err) -> done err

    track.updated = Date.now()
    @redis
      .multi()
      .hset @key('tracks'), track.uri, JSON.stringify track
      .hset @key('votes', track.uri), clientId, 1
      .sadd @key('voted') track.uri
      .exec onExec

    this

  downvoteTrack: (track, done) ->
    onExec = (err) -> done err

    track.updated = Date.now()
    @redis
      .multi()
      .hset @key('tracks'), track.uri, JSON.stringify track
      .hset @key('votes', track.uri), clientId, -1
      .sadd @key('voted') track.uri
      .exec onExec

    this

  getTrackVotes: (track, done) ->
    gotVotes = (err, votes) ->
      return done err if err

      unless votes
        return done null, 0

      votes = 0
      for client, val of votes
        votes + (+val)

      done null, votes

    @redis.hgetall @key('tracks', track.uri), gotVotes

    this

  resetTrack: (track, done) ->
    gotVotes = (err, votes) =>
      return done err if err

      @redis
        .multi()
        .hset @key('previous'), track.uri, votes
        .del @key('votes', track.uri)
        .zadd @key('pool'), track.uri, votes
        .exec onExec

    onExec = (err) -> done err

    @getTrackVotes track, gotVotes

  removeTrack: (track, done) ->
    onExec = (err) -> done err

    @redis
      .multi()
      .hdel @key('tracks'), track.uri
      .del @key('votes', track.uri)
      .hdel @key('previous'), track.uri
      .zrem @key('pool'), track.uri
      .exec onExec

    this

  #
  # Gets the current queue with votes
  #
  # @param Function done
  #
  getQueue: (done) ->
    # err, tracks
    #
    # prefix:queue
    # Sorted set
    #
    # uri votes.timestamp
    this

module.exports = RedisAdapter
